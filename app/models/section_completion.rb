class SectionCompletion < ActiveRecord::Base
  belongs_to :section
  belongs_to :user
  has_many :user_responses
  has_many :questions, -> { order 'position asc' }, through: :user_responses
  has_many :concepts, through: :questions
  has_one :practice_test, through: :section
  belongs_to :test_completion

  accepts_nested_attributes_for :user_responses, reject_if: proc { |attributes| attributes['value'].blank? }

  delegate :name, to: :section, prefix: true
  delegate :questions_count, to: :section, prefix: true

  scope :math, -> { joins(section: :subject).where(subjects: { name: 'Math'}) }
  scope :reading, -> { joins(section: :subject).where(subjects: { name: 'Reading'}) }
  scope :critical_reading, -> { joins(section: :subject).where(subjects: { name: 'Reading'}) }
  scope :writing, -> { joins(section: :subject).where(subjects: { name: 'Writing'}) }
  scope :completed, -> {where(status: "Completed")}

  STATUS = ["Completed", "In-Progress", "Not Started"]
  ACCURACY_POINTS_BOOST = 10

  STATUS.each do |status|
    singleton_class.send(:define_method, :"#{status.downcase.underscore}") { where(:status => status) }

    define_method(:"#{status.downcase.underscore}?") { self.status == status }
  end

  def self.not_started_or_in_progress
    self.where(status: ["In-Progress", "Not Started"])
  end

  def self.for_section_and_user(section, user)
    SectionCompletion.where(section: section, user: user).first || NullSectionCompletion.new(section)
  end

  def self.points_for_user_and_subject(user, subject_scope='math')
    first_section_id = SectionCompletion.completed.send(subject_scope).select('section_completions.id').where(user: user).order('section_completions.created_at asc').first
    first_section_number_correct = UserResponse.where(section_completion_id: first_section_id).where(correct: true).count

    last_section_id = SectionCompletion.completed.send(subject_scope).select('section_completions.id').where(user: user).order('section_completions.created_at desc').first
    last_section_number_correct = UserResponse.where(section_completion_id:last_section_id).where(correct: true).count

    last_section_number_correct * ACCURACY_POINTS_BOOST - first_section_number_correct * ACCURACY_POINTS_BOOST
  end

  def in_progress!
    update_attributes status: "In-Progress"
  end

  def all_questions_answered?
    user_responses.count == section.questions_count
  end

  def complete!
    update_attributes status: 'Completed'
    create_skipped_responses_for_section_completion
    StatRunner.perform_async(self.id) if scoreable?
  end

  def total_time
    user_responses.sum(:time)
  end

  def total_correct
    user_responses.where(correct: true).count
  end

  def accuracy
    total_correct.to_f/section.questions_count.to_f * 100
  end

  def retake?
    SectionCompletion.where(section: section, user: user).count > 1
  end

  def set_scoreable!
    self.update_attributes(scoreable: true) unless retake?
  end

  def user_responses_sorted_by_question_position
    user_responses.sort_by{|r| r.question.position}
  end

  private
    def create_skipped_responses_for_section_completion
      return if self.all_questions_answered?
      self.section.questions.each do |question|
        find_or_create_skipped_response(question)
      end
    end

    def find_or_create_skipped_response(question)
      user_response = UserResponse.where(question: question, section_completion: self).first
      unless user_response
        UserResponse.create!(section_completion: self, value: Question::SKIP_VALUE, question: question)
      end
    end

end
