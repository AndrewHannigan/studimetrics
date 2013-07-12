module ProfileHelper
  def display_concept_progress
    concept_progresses = ConceptProgress.generate_for_user(current_user)
    render "concept_progresses/table", concept_progresses: concept_progresses
  end
end
