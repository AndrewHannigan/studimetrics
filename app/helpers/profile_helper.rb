module ProfileHelper
  def concept_progress_table
    concept_progresses = ConceptProgress.generate_for_user(current_user)
    render "concept_progresses/table", concept_progresses: concept_progresses
  end
end
