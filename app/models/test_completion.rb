class TestCompletion
  attr_accessor :user, :practice_test, :test_progress

  def initialize(options={})
    @user = options[:user]
    @practice_test = options[:practice_test]
    @test_progress = TestProgress.new(user: user, practice_test: practice_test)
  end

  def section_completions
    @section_completions ||= SectionCompletion.select("DISTINCT ON (section_id, user_id) *").where(user: user, section_id: practice_test.section_ids).order("section_id, user_id, id asc")
  end

  def retake_available?
    test_progress.completed?
  end
end
