class FocusRank < ActiveRecord::Base
  AVERAGE_RESPONSE_TIME = {"Math" => 20, "Reading" => 30, "Writing" => 25}
  THRESHOLD = 0.30
  DISPLAY_LIMIT = 10
  TARGET_CONCEPT_LIMIT = 3
  attr_accessor :accuracy

  belongs_to :user, touch: true
  belongs_to :concept
  default_scope {order("focus_ranks.score desc")}
  delegate :name, to: :concept, prefix: true

  before_destroy :clear_focusrank_cache

  def previous_focus_rank
    FocusRank.where(concept_id: self.concept_id, user_id: self.user_id)
      .where("id < #{self.id}").first
  end

  def subject
    Subject.joins(:concepts).where(concepts: {id: self.concept_id}).first
  end

  def self.update_scores_for_concepts_and_user(concepts, user)
    concepts.each do |concept|
      focus_rank = self.where(concept: concept).where(user: user).new
      next unless focus_rank.valid_focus_rank?
      focus_rank.update!
    end
    self.update_deltas_for_user(user)
  end

  def self.target_concepts_for_user(user)
    self.sorted_target_concepts_for_user(user)[0,TARGET_CONCEPT_LIMIT]
  end

  def self.sorted_target_concepts_for_user(user)
    list = self.current_stats_for_user(user)
    list.sort{|x,y,| y.score <=> x.score}
  end

  def self.target_subject_for_user(user)
    Rails.cache.fetch("target_subject_for_user_#{user.id}") do
      target = nil
      max_score = 0
      Subject.all.each do |subj|
        score = self.targeted_concepts_for_user_and_subject(user, subj).collect{|fr| fr.score}.inject(:+)
        next unless score
        if score > max_score
          max_score = score
          target = subj
        end
      end
      target
    end
  end

  def self.sorted_stats_by_user_by_score(user)
    self.current_stats_for_user(user).sort{|x,y| y.score <=> x.score}
  end

  def valid_focus_rank?
    (total_correct + total_incorrect) > 0
  end

  def self.concept_ids_requiring_focus_for_user(user)
    Rails.cache.fetch [user, 'focus_rank_concept_ids'] do
      return [] unless user.focus_ranks.present?
      limit = (user.focus_ranks.count * THRESHOLD).round
      user.focus_ranks.limit(limit).pluck(:concept_id)
    end
  end

  def self.concepts_require_focus_by_user?(concept_ids, user)
    require_focus = concept_ids_requiring_focus_for_user(user)
    concept_ids.any?{|concept_id| require_focus.include?(concept_id)}
  end

  def update!
    self.correct = total_correct
    self.incorrect = total_incorrect
    self.score = calculated_score
    self.average_time = average_response_time_for_user
    self.save
  end

  def percentage_complete
    concept_progress.percentage_complete
  end

  def self.grouped_current_stats(user, limit=5)
    Rails.cache.fetch("focus_rank_grouped_stats_for_user_#{user.id}") do
      list = []
      Subject.all.each do |subj|
        list << FocusRank.targeted_concepts_for_user_and_subject(user, subj, limit)
      end
      list
    end
  end

  def self.current_stats_for_user(user, limit=5)
    list = []
    Subject.all.each do |subj|
      list << FocusRank.targeted_concepts_for_user_and_subject(user, subj, limit)
    end

    list.flatten!

    global_sort = list.sort{|x,y|y.score <=> x.score}
    global_sort.each_with_index do |r, i|
      r.position = i + 1
    end

    global_sort.each do |gs|
      item = list.detect{|y| gs == y}
      item.position = gs.position
    end
    list
  end

  def self.targeted_concepts_for_user_and_subject(user, subject, limit=5)
    focus_ranks = FocusRank.unscoped.where(user: user)
      .where(concept_id: subject.concept_ids)
      .joins(concept: :subject)
      .select("distinct on (focus_ranks.concept_id) focus_ranks.concept_id, focus_ranks.*, subjects.name AS subject_name, concepts.name AS concept_name")
      .order("concept_id, focus_ranks.id desc")

    ranks = focus_ranks.sort!{|x,y| y.score <=> x.score}
    ranks = ranks[0,limit] if limit
    ranks
  end

  def accuracy
    (correct.to_f/(correct + incorrect)) * 100
  end

  def self.update_deltas_for_user(user)
    new_stats = self.current_stats_for_user(user, nil)

    new_stats.each do |new_stat|
      previous_focus_rank = new_stat.previous_focus_rank
      if previous_focus_rank
        position_delta = previous_focus_rank.position - new_stat.position
        accuracy_delta = (new_stat.accuracy - previous_focus_rank.accuracy).ceil
      else
        position_delta = 0
        accuracy_delta = 0
      end
      new_stat.update_attributes!(position: new_stat.position, position_delta: position_delta, accuracy_delta: accuracy_delta)
    end
  end

  def frequency_for_user
    responses_for_user.count
  end

  private

    def concept_progress
      @concept_progress ||= ConceptProgress.new(user: user, concept: concept)
    end

    def calculated_score
      big_parens = 1 + ((average_response_time_for_user - average_response_time_for_site_without_user)/average_response_time_for_site_without_user)
      big_parens * total_incorrect
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
      if frequency_for_site_without_user > 0
        total_site_time_without_user/frequency_for_site_without_user
      else
        default_average_time_for_subject
      end
    end

    def default_average_time_for_subject
      AVERAGE_RESPONSE_TIME[self.concept.subject_name]
    end

    def total_correct
      responses_for_user.where(user_responses: {correct: true}).uniq.count
    end

    def total_incorrect
      responses_for_user.where("user_responses.correct != true").uniq.count
    end

    def frequency_for_site_without_user
      responses_for_site_without_user.count
    end

    def clear_focusrank_cache
      Rails.cache.delete("target_subject_for_user_#{user.id}")
      Rails.cache.delete("focus_rank_grouped_stats_for_user_#{user.id}")
    end
end
