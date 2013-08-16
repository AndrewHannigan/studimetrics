class SectionCompletion < ActiveRecord::Base
  STATUS = ["Completed", "In-Progress", "Not Started"]
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
  scope :reading, -> { joins(section: :subject).where(subjects: { name: 'Critical Reading'}) }
  scope :writing, -> { joins(section: :subject).where(subjects: { name: 'Writing'}) }

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
