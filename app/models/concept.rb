class Concept < ActiveRecord::Base
  has_many :questions
  belongs_to :subject
  has_many :focus_ranks

  validates :name, uniqueness: true, presence: true

  delegate :name, to: :subject, prefix: true

end
