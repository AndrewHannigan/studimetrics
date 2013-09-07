module ProfileHelper
  def focus_ranks_table
    focus_ranks = FocusRank.current_stats_for_user(current_user)
    render "focus_ranks/table", focus_ranks: focus_ranks
  end

  def focus_rank_position(focus_rank)
    render "focus_ranks/position", focus_rank: focus_rank
  end

  def focus_rank_accuracy(focus_rank)
    render "focus_ranks/accuracy", focus_rank: focus_rank
  end

  def pie_chart(percentage)
    render "profiles/pie_chart", percentage: percentage
  end

  def display_target_concepts
    target_subject = FocusRank.target_subject_for_user(current_user)
    return unless target_subject
    target_concept_ids = FocusRank.targeted_concepts_for_user_and_subject(current_user, target_subject, 3).collect(&:concept_id)
    target_concepts = Concept.where(id: target_concept_ids)
    render "profiles/target_concepts", target_concepts: target_concepts
  end

  def display_target_subject
    render "profiles/target_subject"
  end
end
