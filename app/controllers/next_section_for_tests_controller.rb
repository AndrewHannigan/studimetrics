class NextSectionForTestsController < ApplicationController
  before_filter :authorize

  def new
    next_section = NextSection.new(user: current_user, practice_test: practice_test)
    return redirect_to new_section_completion_path(section_id: next_section.section.id)
  end

  def practice_test
    @practice_test ||= PracticeTest.find params[:practice_test_id]
  end
end
