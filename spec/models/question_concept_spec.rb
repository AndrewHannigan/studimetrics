require 'spec_helper'

describe QuestionConcept do
  describe "QuestionConcept#percentage_frequency_for_concept" do
    it "returns the frequency a concept appears compared to all question_concepts" do
      concept = create :concept
      concept2 = create :concept, name: "A different concept"
      3.times { create :question_concept, concept: concept}
      create :question_concept, concept: concept2

      expect(QuestionConcept.percentage_frequency_for_concept(concept)).to eq 0.75
    end
  end

  describe "QuestionConcept#frequency_for_concept" do
    it "returns the frequency count for a given concept" do
      concept = create :concept
      2.times { create :question_concept, concept: concept}

      expect(QuestionConcept.frequency_for_concept(concept)).to eq 2
    end
  end
end
