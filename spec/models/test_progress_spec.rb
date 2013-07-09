require 'spec_helper'

describe TestProgress do
  describe "#percentage_complete" do
    context "with one out of 2 questions answered" do
      it "returns 50" do
        question = create :question, :with_answers
        question2 = create :question, :with_answers, section: question.section
        user_response = create :user_response, question: question

        test_progress = TestProgress.new(user: user_response.section_completion.user, practice_test: question.section.practice_test)

        expect(test_progress.percentage_complete).to eq 50
      end
    end

    context "with 0 out of 2 questions answered" do
      it "returns 0" do
        question = create :question, :with_answers
        question2 = create :question, :with_answers, section: question.section
        user = create :user

        test_progress = TestProgress.new(user: user, practice_test: question.section.practice_test)

        expect(test_progress.percentage_complete).to eq 0
      end
    end

    context "with 2 out of 2 questions answered" do
      it "returns 100" do
        question = create :question, :with_answers
        question2 = create :question, :with_answers, section: question.section

        user_response = create :user_response, question: question
        section_completion = user_response.section_completion
        user_response = create :user_response, question: question2, section_completion: section_completion

        test_progress = TestProgress.new(user: user_response.section_completion.user, practice_test: question.section.practice_test)

        expect(test_progress.percentage_complete).to eq 100
      end
    end

    context "with 2 out of 2 questions answered then retakes answering only 1" do
      it "returns 100" do
        question = create :question, :with_answers
        question2 = create :question, :with_answers, section: question.section


        user_response = create :user_response, question: question
        section_completion = user_response.section_completion
        user_response = create :user_response, question: question2, section_completion: section_completion

        section_completion2 = create :section_completion, user: section_completion.user
        user_response = create :user_response, question: question, section_completion: section_completion2

        test_progress = TestProgress.new(user: user_response.section_completion.user, practice_test: question.section.practice_test)

        expect(test_progress.percentage_complete).to eq 100
      end
    end
  end
end
