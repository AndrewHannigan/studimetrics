class PracticeTestsController < ApplicationController
  before_filter :authorize

  def index
    if current_user.has_responses?
      last_section_completion = SectionCompletion.not_started_or_in_progress.where(user_id: current_user.id).last

      if last_section_completion.present?
        return redirect_to new_section_completion_path(section_id: last_section_completion.section_id)
      else
        # redirect to review page if they have nothing left to do?
      end
    else
      diagnostic_test = PracticeTest.first
      return redirect_to new_section_completion_path(section_id: diagnostic_test.first_section.id)
    end
  end

  def next
    practice_test = PracticeTest.find params[:id]
    next_test = NextTest.new(current_user, practice_test).practice_test
    redirect_to new_practice_test_next_section_for_test_path(practice_test_id: next_test.id)
  end

end
