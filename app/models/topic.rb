class Topic < ActiveRecord::Base
  has_many :questions
  validates :name, uniqueness: true, presence: true
end
