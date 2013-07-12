require 'spec_helper'

describe ConceptProgress do

  describe "ConceptProgress#generate_concept_progresses_for_user" do
    it "creates concept progresses for all concepts for the user" do
      user = create :user
      topic = create :topic
      topic2 = create :topic
      concept_progresses = ConceptProgress.generate_for_user(user)

      expect(concept_progresses.length).to eq 2
      expect(concept_progresses.map(&:user)).to eq [user, user]
      expect(concept_progresses.map(&:topic).sort).to eq [topic, topic2].sort
    end
  end

  describe "#percentage_complete" do
    it "returns 0 when no questions have been answered for a given concept" do
      question = create :question, :with_answers
      user = create :user

      concept_progress = ConceptProgress.new(user: user, topic: question.topic)
      expect(concept_progress.percentage_complete).to eq 0
    end

    it "returns 50 when when 1 out of 2 questions have been answered" do
      question = create :question, :with_answers
      question = create :question, :with_answers, topic: question.topic, section: question.section
      user = create :user

      section_completion = create :section_completion, section: question.section, user: user, scoreable: true
      user_response = create :user_response, question: question, section_completion: section_completion

      concept_progress = ConceptProgress.new(user: user, topic: question.topic)
      expect(concept_progress.percentage_complete).to eq 50
    end

    it "returns 100 when 2 out of 2 questions have been answered in different tests" do
      question = create :question, :with_answers
      question2 = create :question, :with_answers, topic: question.topic
      user = create :user

      section_completion = create :section_completion, section: question.section, user: user, scoreable: true
      user_response = create :user_response, question: question, section_completion: section_completion

      section_completion2 = create :section_completion, section: question2.section, user: user, scoreable: true
      user_response2 = create :user_response, question: question2, section_completion: section_completion2

      concept_progress = ConceptProgress.new(user: user, topic: question.topic)
      expect(concept_progress.percentage_complete).to eq 100
    end

    it "returns 50 when 1 out of 2 questions have been answered twice" do
      question = create :question, :with_answers
      question2 = create :question, :with_answers, topic: question.topic
      user = create :user

      section_completion = create :section_completion, section: question.section, user: user, scoreable: true
      user_response = create :user_response, question: question, section_completion: section_completion

      section_completion2 = create :section_completion, section: question.section, user: user, scoreable: false
      user_response2 = create :user_response, question: question, section_completion: section_completion2

      concept_progress = ConceptProgress.new(user: user, topic: question.topic)
      expect(concept_progress.percentage_complete).to eq 50
    end
  end

  describe "#average_time_for_responses" do
    it "returns average of time for responses in seconds" do
      question = create :question, :with_answers
      question2 = create :question, :with_answers, topic: question.topic
      user = create :user

      section_completion = create :section_completion, section: question.section, user: user, scoreable: true
      user_response = create :user_response, question: question, section_completion: section_completion, time: 60

      section_completion2 = create :section_completion, section: question2.section, user: user, scoreable: true
      user_response2 = create :user_response, question: question2, section_completion: section_completion2, time: 30

      concept_progress = ConceptProgress.new(user: user, topic: question.topic)
      expect(concept_progress.average_time_for_responses).to eq 45
    end

    it "returns 0 when you have no responses for a given topic" do
      question = create :question, :with_answers
      user = create :user

      concept_progress = ConceptProgress.new(user: user, topic: question.topic)

      expect(concept_progress.average_time_for_responses).to eq 0
    end
  end

  describe "#frequency" do
    it "returns total questions for that topic across all tests" do
      question = create :question
      question2 = create :question, topic: question.topic

      concept_progress = ConceptProgress.new(topic: question.topic)

      expect(concept_progress.frequency).to eq 2
    end
  end


  describe "#accuracy" do
    it "returns percentage of questions answered correctly" do
      question = create :question, :with_answers
      question2 = create :question, :with_answers, topic: question.topic
      user = create :user

      section_completion = create :section_completion, section: question.section, user: user, scoreable: true
      user_response = create :user_response, question: question, section_completion: section_completion

      section_completion2 = create :section_completion, section: question2.section, user: user, scoreable: true
      user_response2 = create :user_response, question: question2, value: "B", section_completion: section_completion2

      concept_progress = ConceptProgress.new(user: user, topic: question.topic)

      expect(user_response.correct?).to eq true
      expect(user_response2.correct?).to eq false
      expect(concept_progress.accuracy).to eq 50
    end
  end

end
