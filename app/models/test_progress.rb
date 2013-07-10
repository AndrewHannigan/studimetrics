class TestProgress
  attr_accessor :user, :practice_test, :percentage_complete

  def initialize(options={})
    self.user = options[:user]
    self.practice_test = options[:practice_test]
  end

  def percentage_complete
    @percentage_complete ||= adjusted_percent
  end

  def complete?
    percentage_complete == 100
  end

  private

    def adjusted_percent
      percent = calculate_percent
      (percent > 1 ? 1 : percent) * 100
    end

    def calculate_percent
      return 0 if total_questions_for_test == 0
      (total_completed_questions_for_test.to_f/total_questions_for_test).round(2)
    end

    def total_questions_for_test
      question_ids_for_test.count
    end

    def question_ids_for_test
      @question_ids_for_test ||= practice_test.question_ids
    end

    def total_completed_questions_for_test
      UserResponse.joins(:section_completion)
        .where(user_responses: {question_id: question_ids_for_test})
        .where(section_completions: {user_id: user.id}).count
    end
end
