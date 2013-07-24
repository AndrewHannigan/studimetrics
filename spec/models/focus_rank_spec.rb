require 'spec_helper'

describe FocusRank do
  describe "#calculated_focus_rank" do
    it "returns value according to formula" do
      setup_background
      focus_rank = create :focus_rank, user: @user, concept: @concept

      focus_rank.update!

      expect(focus_rank.correct).to eq 1
      expect(focus_rank.incorrect).to eq 1
      expect(focus_rank.average_time.to_f).to eq 100
      expect(focus_rank.score.to_f).to eq 0.5714285714285714
    end
  end

  describe "FocusRank#update_scores_for_concepts_and_user" do
    it "should find or create a focus rank and update!" do
      user = create :user

      concept1 = create :concept
      concept2 = create :concept

      concepts = [concept1, concept2]
      FocusRank.any_instance.expects(:update!).twice

      FocusRank.update_scores_for_concepts_and_user(concepts, user)
    end
  end
end


def setup_background
  @user = create :user
  user2 = create :user

  @concept = create :concept, name: "Algebra"
  concept2 = create :concept, name: "Geometry"

  question = create :free_response_question, value: 2.0
  create :question_concept, question: question, concept: @concept

  question2 = create :free_response_question, value: 2.0, section: question.section
  create :question_concept, question: question2, concept: @concept

  section_completion = create :section_completion, user: @user, section: question.section
  section_completion2 = create :section_completion, user: user2, section: question.section

  user_response = create :user_response, question: question, value: 2.0, section_completion: section_completion, time: 100
  user_response = create :user_response, question: question2, value: 2.5, section_completion: section_completion, time: 100

  user_response = create :user_response, question: question, value: 2.0, section_completion: section_completion2, time: 200
  user_response = create :user_response, question: question2, value: 2.5, section_completion: section_completion2, time: 150
end
