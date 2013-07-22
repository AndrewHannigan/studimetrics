class CompositeScore < ActiveRecord::Base
  RECENT_QUESTIONS = 15
  AVERAGE_QUESTIONS_FOR_SUBJECT = {"Math" => 50, "Critical Reading" => 50, "Writing" => 50}

  belongs_to :user
  belongs_to :subject
  delegate :name, to: :subject, prefix: true
  delegate :concepts, to: :subject, prefix: true

  def update!(concepts=nil)
    concepts ||= subject_concepts
    concepts.each {|concept| update_concept(concept)}
    self.composite_score = calculated_composite_score
    self.save!
  end

  def calculated_composite_score
    pre_correction_score - subtracted_value_from_precorrection_value
  end

  def update_concept(concept)
    self.concepts["concept_#{concept.id}"] = {
      correct: total_correct_user_responses_for_concept(concept),
      incorrect: total_incorrect_user_responses_for_concept_excluding_free_responses(concept)
    }
  end

  private

    def pre_correction_score
      raw_precorrection_score = (total_correct_excluding_incorrect_free_responses.to_f/total_frequency_excluding_incorrect_free_responses)
      precorrection_score = raw_precorrection_score * AVERAGE_QUESTIONS_FOR_SUBJECT[subject_name]
    end

    def subtracted_value_from_precorrection_value
      0.25 * (1 - (pre_correction_score/AVERAGE_QUESTIONS_FOR_SUBJECT[subject_name]))
    end

    def total_correct_excluding_incorrect_free_responses
      result = 0
      self.concepts.each do |concept_key, value|
        result+= value[:correct]
      end
      result
    end

    def total_frequency_excluding_incorrect_free_responses
      result = 0
      self.concepts.each do |concept_key, value|
        result+= value[:incorrect] + value[:correct]
      end
      result
    end

    def user_responses_for_concept_excluding_incorrect_free_responses(concept, limit=RECENT_QUESTIONS)
      UserResponse.joins(question: :concepts)
      .where(concepts: {id: concept.id}).limit(limit).order("user_responses.created_at desc")
      .where("questions.question_type = 'Free Response' AND user_responses.correct != 'false' OR questions.question_type != 'Free Response'")
      .select("user_responses.id")
    end

    def total_correct_user_responses_for_concept(concept)
      user_responses_for_concept_excluding_incorrect_free_responses(concept)
        .where(user_responses: {correct: true})
        .uniq.count
    end

    def total_incorrect_user_responses_for_concept_excluding_free_responses(concept)
      user_responses_for_concept_excluding_incorrect_free_responses(concept)
        .where(user_responses: {correct: false})
        .uniq.count
    end

    def concept_for_key(concept_key)
      concept_id = concept_key.gsub!("concept_", "").to_i
      Concept.find(concept_id)
    end
end
