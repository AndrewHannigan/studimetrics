require 'spec_helper'

describe RawScoreCalculator do
  describe "#collect_scores" do
    context "returns raw score for each subject" do
      it "returns 0.75 for 1 out of 2 non-free response questions correct" do
        setup_questions

        user_response = create :user_response, question: @question, value:"2.6"
        create :user_response, question: @question2, value: "1.75", section_completion: user_response.section_completion
        test_completion = create :test_completion, practice_test: @question.section.practice_test, user: user_response.section_completion.user

        raw_score_calculator = RawScoreCalculator.new(test_completion)
        expect(raw_score_calculator.collect_scores["Math"]).to eq 0.75

      end

      it "returns 2 for 2 out of 2 non-free response questions correct" do
        setup_questions
        user_response = create :user_response, question: @question, value:"2.6"
        create :user_response, question: @question2, value: "2.5", section_completion: user_response.section_completion
        test_completion = create :test_completion, practice_test: @question.section.practice_test, user: user_response.section_completion.user

        raw_score_calculator = RawScoreCalculator.new(test_completion)

        expect(raw_score_calculator.collect_scores["Math"]).to eq 2.00

      end

      it "returns 0 when 2 out of 2 free response questions are wrong" do
        setup_subject

        question = create :free_response_question, value: "5.0", section: @section
        question2 = create :free_response_question, value: "5.0", section: @section

        user_response = create :user_response, question: question, value: "4.0"
        create :user_response, question: question2, value: "2.5", section_completion: user_response.section_completion
        test_completion = create :test_completion, practice_test: question.section.practice_test, user: user_response.section_completion.user

        raw_score_calculator = RawScoreCalculator.new(test_completion)

        expect(raw_score_calculator.collect_scores["Math"]).to eq 0.00
      end
    end
  end
end

def setup_subject
  @subj = create :subject, name: "Math"
  @section = create :section, subject: @subj
end

def setup_questions
  setup_subject
  @subj = create :subject, name: "Math"
  @section = create :section, subject: @subj

  @question = create :range_question, min_value: "2.5", max_value: "5.0", section: @section
  @question2 = create :range_question, min_value: "2.0", max_value: "5.0", section: @section
end

