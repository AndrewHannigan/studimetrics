class NextSection
  cattr_accessor :user, :practice_test, :test_completion

  def self.for_practice_test_and_user(practice_test, user)
    self.practice_test = practice_test
    self.user = user
    self.test_completion = TestCompletion.where(practice_test_id: practice_test.id, user_id: user.id).first
    in_progress_section || lowest_section_not_started_for_test_run
  end

  private

  class << self

    def in_progress_section
      return nil unless self.test_completion
      test_completion.section_completions.where(status: "In-Progress").order("updated_at desc").first.try(:section)
    end

    def lowest_section_not_started_for_test_run
      ids_for_test = practice_test.section_ids
      if test_completion
        ids_started_or_completed =  test_completion.section_completions.where("status != 'Not Started'").pluck(:section_id)
      else
        ids_started_or_completed = []
      end
      section_id = (ids_for_test - ids_started_or_completed).sort.first
      Section.where(id: section_id).first
    end
  end
end
