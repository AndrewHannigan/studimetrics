class CompositeScore < ActiveRecord::Base
  RECENT_QUESTIONS = 15
  AVERAGE_QUESTIONS_FOR_SUBJECT = {"Math" => 54, "Critical Reading" => 67, "Writing" => 49}

  belongs_to :user
  belongs_to :subject
  delegate :name, to: :subject, prefix: true
  delegate :concepts, to: :subject, prefix: true

  def self.projected_score_for_user_and_subject(user, subject)
    subj = subject.is_a?(Subject) ? subject : Subject.where(name: subject).first
    CompositeScore.where(user: user, subject: subj).first.try(:projected_score)
  end

  def self.projected_total_score_for_user(user)
    scores = Subject.all.collect do |subj|
      self.projected_score_for_user_and_subject(user, subj)
    end
    return nil if scores.include?(nil)
    scores.inject(:+)
  end

  def update!(concepts=nil)
    self.composite_score = calculated_composite_score
    self.save!
  end

  def projected_score
    ConversionTable.converted_score(subject.acronym, rounded_score)
  end


  def calculated_composite_score
    pre_correction_score - subtracted_value_from_precorrection_value
  end

  private

    def rounded_score
      composite_score.to_f.round(0)
    end

    def pre_correction_score
      concept_pre_correction_sum = 0
      concept_ids_with_responses.each do |concept_id|
        accuracy = accuracy_for_concept(concept_id)
        concept_frequency = QuestionConcept.percentage_frequency_for_concept(concept_id)
        concept_pre_correction_sum += accuracy * concept_frequency * AVERAGE_QUESTIONS_FOR_SUBJECT[subject_name]
      end
      concept_pre_correction_sum
    end

    def accuracy_for_concept(concept_id)
      (total_correct_user_responses_for_concept(concept_id).to_f)/user_responses_for_concept_excluding_incorrect_free_responses(concept_id).count
    end

    def subtracted_value_from_precorrection_value
      (0.25 * (AVERAGE_QUESTIONS_FOR_SUBJECT[subject_name] - pre_correction_score))
    end

    def user_responses_for_concept_excluding_incorrect_free_responses(concept_id, limit=RECENT_QUESTIONS)
      UserResponse.joins(:section_completion, question: :concepts)
      .where(section_completions: {user_id: user.id})
      .where(concepts: {id: concept_id}).limit(limit).order("user_responses.created_at desc")
      .where("questions.question_type = 'Free Response' AND user_responses.correct != 'false' OR questions.question_type != 'Free Response'")
      .select("user_responses.id")
    end

    def total_correct_user_responses_for_concept(concept_id)
      user_responses_for_concept_excluding_incorrect_free_responses(concept_id)
        .where(user_responses: {correct: true})
        .uniq.count
    end

    def total_incorrect_user_responses_for_concept_excluding_free_responses(concept_id)
      user_responses_for_concept_excluding_incorrect_free_responses(concept_id)
        .where(user_responses: {correct: false})
        .uniq.count
    end

    def concept_ids_with_responses
      UserResponse.joins(:section_completion, question: {concepts: :subject})
        .where(section_completions: {user_id: user.id})
        .where(subjects: {id: subject.id})
        .select("concepts.id, user_response.id").pluck(:concept_id).uniq
    end

end
