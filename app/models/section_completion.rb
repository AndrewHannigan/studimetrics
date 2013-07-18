class SectionCompletion < ActiveRecord::Base
  STATUS = ["Completed", "In-Progress", "Not Started"]
  belongs_to :section
  belongs_to :user
  has_many :user_responses
  has_many :questions, -> { order 'position asc' }, through: :user_responses
  has_one :practice_test, through: :section
  belongs_to :test_completion

  accepts_nested_attributes_for :user_responses, reject_if: proc { |attributes| attributes['value'].blank? }

  delegate :name, to: :section, prefix: true
  delegate :questions_count, to: :section, prefix: true

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

  def complete!
    update_attributes status: 'Completed'
    test_completion.try(:update!)
  end

  def total_time
    user_responses.sum(:time)
  end

  def total_correct
    user_responses.where(correct: true).count
  end

  def retake?
    SectionCompletion.where(section: section, user: user).count > 1
  end

  def link_to_test_completion!(test_completion)
    self.update_attributes!(test_completion: test_completion)
  end

  def set_scoreable!
    self.update_attributes(scoreable: true) unless retake?
  end
end
