class Concept < ActiveRecord::Base
  has_many :questions
  belongs_to :subject
  validates :name, uniqueness: true, presence: true

  delegate :name, to: :subject, prefix: true

end
