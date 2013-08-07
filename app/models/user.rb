class User < ActiveRecord::Base
  include Clearance::User
  include ProfileImage

  has_many :focus_ranks
  belongs_to :college
  has_many :section_completions
  has_many :user_responses, through: :section_completions
  has_many :test_completions, -> { order 'created_at asc' }

  delegate :name, to: :college, prefix: true

  # validates :first_name, :last_name, :grade, :state, presence: true

  GRADES = %w(9th 10th 11th 12th)

  def location
    "#{self.city}, #{self.state}"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def current_test
    PracticeTest.first
  end

  def has_responses?
    user_responses.count > 0
  end

  def college
    super || NullCollege.new
  end
end
