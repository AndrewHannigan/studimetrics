class Concept < ActiveRecord::Base
  has_many :questions
  belongs_to :subject
  has_many :focus_ranks
  has_many :concept_videos

  validates :name, uniqueness: true, presence: true

  delegate :name, to: :subject, prefix: true

end
