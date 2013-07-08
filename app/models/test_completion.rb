class TestCompletion
  attr_accessor :user, :practice_test

  def initialize(options={})
    @user = options[:user]
    @practice_test = options[:practice_test]
  end

  def section_completions
    @section_completions ||= SectionCompletion.select("DISTINCT ON (section_id, user_id) *").where(user: user, section_id: practice_test.section_ids).order("section_id, user_id, id asc")
  end
end
