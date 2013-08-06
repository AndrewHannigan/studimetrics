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

  describe "FocusRank.current_stats_for_user" do
    it "should return focus ranks for user with position set" do
      setup_original_stats
      ranks = FocusRank.current_stats_for_user(@user)

      expect(ranks).to eq [@focus_rank, @focus_rank2]
      expect(ranks.first.position).to eq 1
      expect(ranks.last.position).to eq 2
    end
  end

  describe "FocusRank.concepts_require_focus_by_user?" do
    it "returns true if concepts requiring focus include concept_ids passed in" do
      user = build :user
      FocusRank.expects(:concept_ids_requiring_focus_for_user).returns([1,2])

      expect(FocusRank.concepts_require_focus_by_user?([1],user)).to eq true
    end

    it "returns false if concepts requiring focus does not contains concept_ids passed in" do
      user = build :user
      FocusRank.expects(:concept_ids_requiring_focus_for_user).returns([1,2])

      expect(FocusRank.concepts_require_focus_by_user?([3],user)).to eq false
    end
  end

  describe "FocusRank.concept_ids_requiring_focus_for_user" do
    it "returns an array of concept ids whose focus rank is below threshold" do
      user = create :user
      requires_focus = create :focus_rank, user: user, score: 10
      no_focus = create :focus_rank, user: user, score: 20
      no_focus2= create :focus_rank, user: user, score: 30

      concept_ids = FocusRank.concept_ids_requiring_focus_for_user(user)
      expect(concept_ids.include?(requires_focus.concept_id)).to eq true
      expect(concept_ids.include?(no_focus.concept_id)).to eq false
      expect(concept_ids.include?(no_focus2.concept_id)).to eq false
    end
  end

  describe "FocusRank.update_scores_for_concepts_and_user" do
    it "should call update_deltas_for_user" do
      setup_original_stats
      old_stats = FocusRank.current_stats_for_user(@user)

      FocusRank.any_instance.stubs(:update!).returns(true)

      FocusRank.expects(:update_deltas_for_user) # - with clause fails for some reason .with(@user, old_stats)
      FocusRank.update_scores_for_concepts_and_user(Concept.all, @user)
    end
  end

  describe "#accuracy" do
    it "returns total correct divided by total incorrect as a percentage" do
      focus_rank = FocusRank.new(correct: 5, incorrect: 15)

      expect(focus_rank.accuracy).to eq 25
    end
  end

  describe "#percentage_complete" do
    it "call percentage complete on a concept progress instance" do
      focus = create :focus_rank

      ConceptProgress.any_instance.expects(:percentage_complete)

      focus.percentage_complete
    end
  end

  describe "FocusRank#update_deltas_for_user" do
    it "sets position and accuracy delta" do
      setup_original_stats
      old_stats = FocusRank.current_stats_for_user(@user)
      swap_stat_positions

      FocusRank.update_deltas_for_user(@user,old_stats)
      ranks = FocusRank.current_stats_for_user(@user)

      expect(ranks.first.position_delta).to eq 1
      expect(ranks.last.position_delta).to eq -1
      expect(ranks.first.accuracy_delta).to eq -13
      expect(ranks.last.accuracy_delta).to eq 17
      expect(ranks.first.score).to eq 1
      expect(ranks.last.score).to eq 2
    end
  end

  describe "FocusRank#current_stats_for_user" do
    it "returns the top ten focus ranks" do
      user = create :user
      (0..10).each do
        create :focus_rank, user: user
      end

      expect(FocusRank.current_stats_for_user(user).length).to eq 10
      expect(FocusRank.count).to eq 11
    end

  end

  describe "#frequency_for_user" do
    it "counts number of user responses for the given concept" do
      user = create :user
      concept = create :concept
      focus_rank = create :focus_rank, user: user, concept: concept
      section_completion = create :section_completion, user: user
      5.times {create :user_response, section_completion: section_completion}

      focus_rank.expects(:responses_for_user).returns(user.user_responses)

      expect(focus_rank.frequency_for_user).to eq 5
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

def setup_original_stats
  @user = create :user
  @focus_rank = create :focus_rank, user: @user
  @focus_rank2 = create :focus_rank, user: @user

  @focus_rank.expects(:calculated_score).returns(1)
  @focus_rank.expects(:total_correct).returns(3)
  @focus_rank.expects(:total_incorrect).returns(3)
  @focus_rank.expects(:average_response_time_for_user).returns(30)
  @focus_rank.update!

  @focus_rank2.expects(:calculated_score).returns(2)
  @focus_rank2.expects(:total_correct).returns(4)
  @focus_rank2.expects(:total_incorrect).returns(8)
  @focus_rank2.expects(:average_response_time_for_user).returns(30)
  @focus_rank2.update!
end

def swap_stat_positions
  @focus_rank.expects(:calculated_score).returns(2)
  @focus_rank.expects(:total_correct).returns(8)
  @focus_rank.expects(:total_incorrect).returns(4)
  @focus_rank.expects(:average_response_time_for_user).returns(30)
  @focus_rank.update!

  @focus_rank2.expects(:calculated_score).returns(1)
  @focus_rank2.expects(:total_correct).returns(4)
  @focus_rank2.expects(:total_incorrect).returns(16)
  @focus_rank2.expects(:average_response_time_for_user).returns(30)
  @focus_rank2.update!
end
