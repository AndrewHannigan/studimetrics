class Concept < ActiveRecord::Base
  has_many :questions
  belongs_to :subject
  has_many :focus_ranks
  has_many :concept_videos

  validates :name, uniqueness: true, presence: true

  delegate :name, to: :subject, prefix: true

  ADDITIONAL_CONCEPTS_FOR_SIDEBAR = ['Vocabulary']

  def self.for_sidebar
    concept = arel_table
    not_reading_subject_ids = Subject.not_reading.pluck(:id)
    where(concept[:subject_id].in(not_reading_subject_ids).or(concept[:name].in(ADDITIONAL_CONCEPTS_FOR_SIDEBAR))).order(:name)
  end

  def underscored_concept_name
    name.titleize.gsub(/\//,' ').gsub(/\s+/, '_').underscore
  end

end
