require 'spec_helper'

describe ConceptProgress do
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
end
