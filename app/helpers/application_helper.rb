module ApplicationHelper

  def last_activity_and_suggested_display(user)
    render "last_activity_and_suggested_display", user: user
  end

  def display_test_percentage_complete(practice_test)
    test_progress = TestProgress.new(user: current_user, practice_test: practice_test)
    render "test_percentage_complete", test_progress: test_progress
  end
end

