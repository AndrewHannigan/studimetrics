class NextSectionForTestsController < ApplicationController
  before_filter :authorize

  def new
    practice_test = PracticeTest.find params[:practice_test_id]

    if params[:current_section].present?
      current_section = Section.find params[:current_section]
      next_section = NextSection.for_current_section current_section
    else
      next_section = NextSection.for_user_and_practice_test(current_user, practice_test)
    end

    return redirect_to new_section_completion_path(section_id: next_section.id)
  end

end
