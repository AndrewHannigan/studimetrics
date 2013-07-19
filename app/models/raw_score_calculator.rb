class RawScoreCalculator
  attr_accessor :test_completion, :math, :critical_reading, :writing

  def initialize(test_completion)
    self.test_completion = test_completion
  end

  def update_scores!
    Subject.all.each {|subj| update_subject_score(subj)}
  end

  private
    def update_subject_score(subj)
      total_correct = total_correct_for_subject(subj)
      total_incorrect = total_incorrect_excluding_free_response_for_subject(subj)

      raw_score = total_correct - (total_incorrect * 0.25)
      test_completion.send("#{raw_score_field_for_subject(subj)}=", raw_score)
      test_completion.save!
    end

    def total_correct_for_subject(subj)
      UserResponse.joins(section_completion: {section: :practice_test})
        .where(practice_tests: {id: test_completion.practice_test_id})
        .where(sections: {subject_id: subj.id})
        .where(user_responses: {correct: true}).count

    end

    def total_incorrect_excluding_free_response_for_subject(subj)
      UserResponse.joins(:question, section_completion: {section: :practice_test})
        .where(practice_tests: {id: test_completion.practice_test_id})
        .where(sections: {subject_id: subj.id})
        .where(questions: {question_type: ["Multiple Choice", "Range"]})
        .where(user_responses: {correct: false}).count

    end

    def raw_score_field_for_subject(subj)
      "raw_#{subj.name.split(" ").join("").underscore}_score"
    end
end
