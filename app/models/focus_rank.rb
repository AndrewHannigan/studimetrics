class FocusRank < ActiveRecord::Base
  belongs_to :user
  belongs_to :concept

  def self.update_scores_for_concepts_and_user(concepts, user)
    concepts.each do |concept|
      focus_rank = FocusRank.where(concept: concept).where(user: user).first_or_create
      focus_rank.update!
    end
  end

  def update!
    self.correct = total_correct
    self.incorrect = total_incorrect
    self.score = calculated_score
    self.average_time = average_response_time_for_user
    self.save
  end

  private

    def calculated_score
      big_parens = 1 + ((average_response_time_for_user - average_response_time_for_site_without_user)/average_response_time_for_site_without_user)
      big_parens * total_correct
    end

    def total_site_time_without_user
      responses_for_site_without_user.sum(:time).to_f
    end

    def responses_for_site_without_user
      UserResponse.where("section_completion_id NOT in (?)", user.section_completion_ids).uniq
    end

    def responses_for_user
      user.user_responses
        .joins(question: :concepts)
        .where(concepts: {id: concept_id}).uniq
    end

    def total_time_for_user
      responses_for_user.sum(:time).to_f
    end

    def average_response_time_for_user
      total_time_for_user.to_f/frequency_for_user
    end

    def average_response_time_for_site_without_user
      total_site_time_without_user/frequency_for_site_without_user
    end

    def total_correct
      responses_for_user.where(user_responses: {correct: true}).uniq.count
    end

    def total_incorrect
      responses_for_user.where(user_responses: {correct: false}).uniq.count
    end

    def frequency_for_user
      responses_for_user.count
    end

    def frequency_for_site_without_user
      responses_for_site_without_user.count
    end
end
