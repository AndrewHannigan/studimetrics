class Topic < ActiveRecord::Base
  has_many :questions
  validates :name, uniqueness: true, presence: true
  belongs_to :subject

  delegate :name, to: :subject, prefix: true
end
