class Concept < ActiveRecord::Base
  has_many :questions
  belongs_to :subject
  has_many :focus_ranks, dependent: :destroy
  has_many :concept_videos, dependent: :destroy

  validates :name, uniqueness: true, presence: true
  scope :last_updated, ->{order("updated_at desc").first}

  delegate :name, to: :subject, prefix: true

  ADDITIONAL_CONCEPTS_FOR_SIDEBAR = ['Reading Passage Questions', 'Vocabulary']
  PARENT_CONCEPTS = [
    { "Reading Passage Questions" => ['Inference', 'Direct Interpretation', 'Vocabulary-in-Context', 'Elements of Writing', 'Summarization', 'Tone/Attitude/Emotion'] }
  ]

  def self.filtered
    concept = arel_table
    not_reading_subject_ids = Subject.not_reading.pluck(:id)
    where(concept[:subject_id].in(not_reading_subject_ids).or(concept[:name].in(ADDITIONAL_CONCEPTS_FOR_SIDEBAR))).order(:name)
  end

  def self.image_path(concept)
    concept_name = concept.is_a?(String) ? concept : concept.name
    concept_file_name = underscored_name(concept_name)
    folder = 'concept_icons'
    image_name = "#{folder}/#{concept_file_name}.png"
    if !Rails.application.assets.find_asset image_name
      image_name = "#{folder}/default.png"
    end
    image_name
  end

  def has_parent_concept?
    parent_concept.present?
  end

  def parent_concept
    Concept.where(name: parent_concept_name).first
  end

  private

  def parent_concept_name
    parent_concept_hash = PARENT_CONCEPTS.detect do |parent_concept|
      parent_concept.values.first.include? name
    end

    if parent_concept_hash.present?
      parent_concept_hash.keys.first
    end
  end

  def self.underscored_name(concept_name)
    concept_name.titleize.gsub(/\//,' ').gsub(/\s+/, '_').underscore
  end

end
