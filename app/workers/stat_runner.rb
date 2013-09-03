class StatRunner
  include Sidekiq::Worker

  attr_accessor :section_completion, :user, :test_completion, :section_completion_id

  def perform(section_completion_id)
    @section_completion_id = section_completion_id
    test_completion.try(:update!)
    composite_score.try(:update!, section_completion.concepts.uniq)
    FocusRank.update_scores_for_concepts_and_user(section_completion.concepts.uniq, section_completion.user)
    Rails.cache.write("user_#{section_completion.user_id}_total_seconds_studied", section_completion.user.total_seconds_studied)
    fill_cache_for_focus_ranks(section_completion.user)
    fill_cache_for_percentage_complete_for_user(section_completion.user)
    fill_cache_for_accuracy_graph
    fill_cache_for_target_subject(section_completion.user)
  end

  private

    def fill_cache_for_target_subject(user)
      Rails.cache.delete("target_subject_for_user_#{user.id}")
      FocusRank.target_subject_for_user(user)
    end

    def fill_cache_for_percentage_complete_for_user(user)
      focus_ranks = FocusRank.grouped_current_stats(user)
      focus_ranks.flatten!
      focus_ranks.each do |focus_rank|
        Rails.cache.write("focus_rank_percentage_complete_#{focus_rank.cache_key}", focus_rank.percentage_complete)
      end
    end

    def fill_cache_for_focus_ranks(user)
      Rails.cache.delete("focus_rank_grouped_stats_for_user_#{user.id}")
      FocusRank.grouped_current_stats(user, 5)
    end

    def fill_cache_for_accuracy_graph
      Subject.find_each do |subj|
        Statistic.new(user).accuracy_for_subject_per_section_completion(subj)
      end
    end

    def section_completion
      @section_completion = SectionCompletion.find(section_completion_id)
    end

    def user
      @user ||= section_completion.user
    end

    def subject
      @subject ||= Subject.joins(sections: :section_completions)
        .where(section_completions: {id: section_completion.id}).first
    end

    def test_completion
      @test_completion ||= section_completion.test_completion
    end


    def composite_score
      @composite_score ||= CompositeScore.where(subject: subject, user: user).first_or_create if section_completion.scoreable?
    end

end
