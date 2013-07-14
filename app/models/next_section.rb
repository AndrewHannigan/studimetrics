class NextSection
  cattr_accessor :user, :practice_test, :next_section, :current_section

  def self.for_user_and_practice_test(user, practice_test)
    self.user = user
    self.practice_test = practice_test
    in_progress_section || lowest_section_not_started_for_test
  end

  def self.for_current_section(current_section)
    next_lowest_numbered_section(current_section) || lowest_section_for_test(current_section.practice_test)
  end

  private

  class << self

    def next_lowest_numbered_section(current_section)
      Section.where(practice_test_id: current_section.practice_test_id).where("number > ?", current_section.number).order("number asc").first
    end

    def lowest_section_for_test(practice_test)
      Section.where(practice_test_id: practice_test.id).order("number asc").first
    end

    def in_progress_section
      SectionCompletion.where(section_id: section_ids, user_id: user.id, status: "In-Progress").order("updated_at desc").first.try(:section)
    end

    def lowest_section_not_started_for_test
      section_id = (section_ids - sections_completed_for_this_test_run).first || section_ids.first
      Section.where(id: section_id).first
    end

    def section_ids
      practice_test.sections.order("number asc").pluck(:id)
    end

    def completed_section_ids_for_test
      SectionCompletion.where(section_id: section_ids, user_id: user.id, status: "Completed").order("updated_at asc").pluck(:section_id)
    end

    def has_completed_test?
      section_ids.length <= completed_section_ids_for_test.length
    end

    def sections_completed_on_this_run
      completed_section_ids_for_test.length % section_ids.length
    end

    def number_of_test_completions
      completed_section_ids_for_test.length/section_ids.length
    end

    def sections_completed_for_this_test_run
      starting_index = number_of_test_completions * section_ids.length
      length = sections_completed_on_this_run
      completed_section_ids_for_test[starting_index,length]
    end
  end
end
