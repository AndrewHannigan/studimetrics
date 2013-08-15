class QuestionConcept < ActiveRecord::Base
  belongs_to :question
  belongs_to :concept

  def self.percentage_frequency_for_concept(concept_id)
    subj = Concept.where(id: concept_id).first.subject
    (self.frequency_for_concept(concept_id).to_f / QuestionConcept.concept_count_for_subject(subj)).round(2)
  end

  def self.frequency_for_concept(concept_id)
    QuestionConcept.where(concept_id: concept_id).count
  end

  def self.concept_count_for_subject(subject)
    QuestionConcept.joins(concept: :subject)
      .where(subjects: {id: subject.id}).count
  end


end
