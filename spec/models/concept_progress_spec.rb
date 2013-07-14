require 'spec_helper'

describe ConceptProgress do

  describe "ConceptProgress#generate_concept_progresses_for_user" do
    it "creates concept progresses for all concepts for the user" do
      user = create :user
      concept = create :concept
      concept2 = create :concept
      concept_progresses = ConceptProgress.generate_for_user(user)

      expect(concept_progresses.length).to eq 2
      expect(concept_progresses.map(&:user)).to eq [user, user]
      expect(concept_progresses.map(&:concept).sort).to eq [concept, concept2].sort
    end
  end

  describe "#percentage_complete" do
    it "returns 0 when no questions have been answered for a given concept" do
      question_concept = create :question_concept
      user = create :user

      concept_progress = ConceptProgress.new(user: user, concept: question_concept.concept)
      expect(concept_progress.percentage_complete).to eq 0
    end

    it "returns 50 when 1 out of 2 questions have been answered" do
      question = create :question, :with_answers
      question_concept = create :question_concept, question: question

      question2 = create :question, :with_answers
      question_concept2 = create :question_concept, question: question2, concept: question_concept.concept
      user = create :user

      section_completion = create :section_completion, section: question.section, user: user, scoreable: true
      user_response = create :user_response, question: question, section_completion: section_completion

      concept_progress = ConceptProgress.new(user: user, concept: question.concepts.first)
      expect(concept_progress.percentage_complete).to eq 50
    end

    it "returns 100 when 2 out of 2 questions have been answered in different tests" do
      question = create :question, :with_answers
      question_concept = create :question_concept, question: question

      question2 = create :question, :with_answers
      question_concept2 = create :question_concept, question: question2, concept: question_concept.concept
      user = create :user

      section_completion = create :section_completion, section: question.section, user: user, scoreable: true
      user_response = create :user_response, question: question, section_completion: section_completion

      section_completion2 = create :section_completion, section: question2.section, user: user, scoreable: true
      user_response2 = create :user_response, question: question2, section_completion: section_completion2

      concept_progress = ConceptProgress.new(user: user, concept: question.concepts.first)
      expect(concept_progress.percentage_complete).to eq 100
    end

    it "returns 50 when 1 out of 2 questions have been answered twice" do
      question = create :question, :with_answers
      question_concept = create :question_concept, question: question

      question2 = create :question, :with_answers
      question_concept2 = create :question_concept, question: question2, concept: question_concept.concept
      user = create :user

      section_completion = create :section_completion, section: question.section, user: user, scoreable: true
      user_response = create :user_response, question: question, section_completion: section_completion

      section_completion2 = create :section_completion, section: question.section, user: user, scoreable: false
      user_response2 = create :user_response, question: question, section_completion: section_completion2

      concept_progress = ConceptProgress.new(user: user, concept: question.concepts.first)
      expect(concept_progress.percentage_complete).to eq 50
    end
  end

  describe "#average_time_for_responses" do
    it "returns average of time for responses in seconds" do
      question = create :question, :with_answers
      question_concept = create :question_concept, question: question

      question2 = create :question, :with_answers
      question_concept2 = create :question_concept, question: question2, concept: question_concept.concept
      user = create :user

      section_completion = create :section_completion, section: question.section, user: user, scoreable: true
      user_response = create :user_response, question: question, section_completion: section_completion, time: 60

      section_completion2 = create :section_completion, section: question2.section, user: user, scoreable: true
      user_response2 = create :user_response, question: question2, section_completion: section_completion2, time: 30

      concept_progress = ConceptProgress.new(user: user, concept: question.concepts.first)
      expect(concept_progress.average_time_for_responses).to eq 45
    end

    it "returns 0 when you have no responses for a given concept" do
      question = create :question, :with_answers
      question_concept = create :question_concept, question: question
      user = create :user

      concept_progress = ConceptProgress.new(user: user, concept: question.concepts.first)

      expect(concept_progress.average_time_for_responses).to eq 0
    end
  end

  describe "#frequency" do
    it "returns total questions for that concept across all tests" do
      question_concept = create :question_concept
      create :question_concept, concept: question_concept.concept

      concept_progress = ConceptProgress.new(concept: question_concept.concept)

      expect(concept_progress.frequency).to eq 2
    end
  end


  describe "#accuracy" do
    it "returns percentage of questions answered correctly" do
      question = create :question, :with_answers
      question_concept = create :question_concept, question: question

      question2 = create :question, :with_answers
      question_concept2 = create :question_concept, question: question2, concept: question_concept.concept
      user = create :user

      section_completion = create :section_completion, section: question.section, user: user, scoreable: true
      user_response = create :user_response, question: question, section_completion: section_completion

      section_completion2 = create :section_completion, section: question2.section, user: user, scoreable: true
      user_response2 = create :user_response, question: question2, value: "B", section_completion: section_completion2

      concept_progress = ConceptProgress.new(user: user, concept: question.concepts.first)

      expect(user_response.correct?).to eq true
      expect(user_response2.correct?).to eq false
      expect(concept_progress.accuracy).to eq 50
    end
  end

end
