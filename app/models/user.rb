class User < ActiveRecord::Base
  include Clearance::User
  has_many :focus_ranks
  belongs_to :college
  has_many :section_completions
  has_many :user_responses, through: :section_completions

  delegate :name, to: :college, prefix: true

  validates :first_name, :last_name, :grade, :state, presence: true

  has_attached_file :profile_image,
    path: "/:hash.:extension",
    hash_secret: "Uk2tEwMEsZ7gsh.WjzFC4jV6hzEdm!!",
    default_url: "/assets/:class/:attachment/:style/missing.png",
    styles: {
      medium: '300x300>',
      thumb: '80x80#'
    }
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
end
