class QuestionConcept < ActiveRecord::Base
  belongs_to :question
  belongs_to :concept

  def self.percentage_frequency_for_concept(concept_id)
    (self.frequency_for_concept(concept_id).to_f / QuestionConcept.count).round(2)
  end

  def self.frequency_for_concept(concept_id)
    QuestionConcept.where(concept_id: concept_id).count
  end


end
