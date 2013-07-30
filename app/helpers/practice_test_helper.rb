module PracticeTestHelper

  def last_activity_for_user(user)
    render "practice_tests/last_activity_for_user", user: user
  end

  def display_test_percentage_complete(practice_test)
    test_progress = TestProgress.new(user: current_user, practice_test: practice_test)
    render "test_percentage_complete", test_progress: test_progress
  end

end
