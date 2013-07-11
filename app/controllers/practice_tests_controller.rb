class PracticeTestsController < ApplicationController
  before_filter :authorize

  def next
    practice_test = PracticeTest.find params[:id]
    next_test = NextTest.new(current_user, practice_test).practice_test
    redirect_to new_practice_test_next_section_for_test_path(practice_test_id: next_test.id)
  end

end
