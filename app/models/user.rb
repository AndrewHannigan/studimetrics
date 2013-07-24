class User < ActiveRecord::Base
  include Clearance::User
  has_one :focus_rank
  has_many :section_completions
  has_many :user_responses, through: :section_completions

  validates :first_name, :last_name, :grade, :state, presence: true
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
end
