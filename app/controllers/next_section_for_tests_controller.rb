class NextSectionForTestsController < ApplicationController
  before_filter :authorize

  def new
    practice_test = PracticeTest.where(id: params[:practice_test_id]).first
    next_section = NextSection.for_practice_test_and_user(practice_test, current_user)
    return redirect_to new_section_completion_path(section_id: next_section.id)
  end

end
