class User < ActiveRecord::Base
  include Clearance::User

  validates :first_name, :last_name, :grade, :state, presence: true
  GRADES = %w(9th 10th 11th 12th)
end
