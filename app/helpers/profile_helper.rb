module ProfileHelper
  def display_concept_progress
    concept_progresses = ConceptProgress.generate_for_user(current_user)
    render "concept_progresses/table", concept_progresses: concept_progresses
  end

  def display_test_completions
    test_completions = TestCompletion.where(user: current_user).includes(:practice_test)
    render "test_completions/table", test_completions: test_completions
  end
end
