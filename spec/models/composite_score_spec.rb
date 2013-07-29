require 'spec_helper'

describe CompositeScore do

  describe "#calculated_composite_score" do
    it "returns score according to formula" do
      subj = create :subject, name: "Math"
      concepts = {"concept_1" => {correct: 2, incorrect: 3}, "concept_2" => {correct: 4, incorrect: 2}, "concept_3" => {correct: 5, incorrect: 0}}
      composite_score = CompositeScore.new(subject: subj, concepts: concepts)

      expect(composite_score.calculated_composite_score).to eq 37.046875
    end
  end

  describe "#update_concept" do
    context "2 correct answers for non free response questions" do
      it "should have 2 correct, 0 incorrect" do
        question = create :range_question, min_value: 2.0, max_value: 5
        concept = create :concept, name: "Geometry"
        create :question_concept, question: question, concept: concept
        user_response = create :user_response, question: question, value: 2.5
        user = user_response.section_completion.user

        question2 = create :range_question, min_value: 2.0, max_value: 5
        create :question_concept, question: question2, concept: concept
        create :user_response, question: question2, value: 2.5, section_completion: user_response.section_completion

        composite_score = CompositeScore.new(user: user, subject: concept.subject)

        composite_score.update_concept(concept)

        expect(composite_score.concepts["concept_#{concept.id}"][:correct]).to eq 2
        expect(composite_score.concepts["concept_#{concept.id}"][:incorrect]).to eq 0
      end
    end

    context "2 incorrect answers for non free response quesstions" do
      it "should have 2 incorrect, 0 correct" do
        question = create :range_question, min_value: 2.0, max_value: 5
        concept = create :concept, name: "Geometry"
        create :question_concept, question: question, concept: concept
        user_response = create :user_response, question: question, value: 1.5
        user = user_response.section_completion.user

        question2 = create :range_question, min_value: 2.0, max_value: 5
        create :question_concept, question: question2, concept: concept
        create :user_response, question: question2, value: 1.5, section_completion: user_response.section_completion

        composite_score = CompositeScore.new(user: user, subject: concept.subject)

        composite_score.update_concept(concept)

        expect(composite_score.concepts["concept_#{concept.id}"][:correct]).to eq 0
        expect(composite_score.concepts["concept_#{concept.id}"][:incorrect]).to eq 2
      end

    end

    context "1 correct answer for free response and 1 incorrect free response" do
      it "should have 1 correct, 0 incorrect" do
        question = create :free_response_question, value: 2.0
        concept = create :concept, name: "Geometry"
        create :question_concept, question: question, concept: concept
        user_response = create :user_response, question: question, value: 2.0
        user = user_response.section_completion.user

        question2 = create :free_response_question, value: 2.0
        create :question_concept, question: question2, concept: concept
        create :user_response, question: question2, value: 1.5, section_completion: user_response.section_completion

        composite_score = CompositeScore.new(user: user, subject: concept.subject)

        composite_score.update_concept(concept)

        expect(composite_score.concepts["concept_#{concept.id}"][:correct]).to eq 1
        expect(composite_score.concepts["concept_#{concept.id}"][:incorrect]).to eq 0
      end
    end

    context "2 incorrect answers for free response" do
      it "should have 0 correct, 0 incorrect" do
        question = create :free_response_question, value: 2.0
        concept = create :concept, name: "Geometry"
        create :question_concept, question: question, concept: concept
        user_response = create :user_response, question: question, value: 1.5
        user = user_response.section_completion.user

        question2 = create :free_response_question, value: 2.0
        create :question_concept, question: question2, concept: concept
        create :user_response, question: question2, value: 1.5, section_completion: user_response.section_completion

        composite_score = CompositeScore.new(user: user, subject: concept.subject)

        composite_score.update_concept(concept)

        expect(composite_score.concepts["concept_#{concept.id}"][:correct]).to eq 0
        expect(composite_score.concepts["concept_#{concept.id}"][:incorrect]).to eq 0
      end
    end
  end

  describe "#projected_score" do
    it "calls to retrieve projected score based on rounded score" do
      composite_score = create :composite_score
      ConversionTable.expects(:converted_score).with(composite_score.subject.acronym, composite_score.send(:rounded_score))

      composite_score.projected_score
    end

  end
end
