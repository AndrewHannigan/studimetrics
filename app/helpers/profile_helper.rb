module ProfileHelper
  def focus_ranks_table
    focus_ranks = FocusRank.current_stats_for_user(current_user)
    render "focus_ranks/table", focus_ranks: focus_ranks
  end

  def display_focus_rank_position(focus_rank)
    render "focus_ranks/position", focus_rank: focus_rank
  end

  def display_focus_rank_accuracy(focus_rank)
    render "focus_ranks/accuracy", focus_rank: focus_rank
  end
end
