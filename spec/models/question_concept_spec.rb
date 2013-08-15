require 'spec_helper'

describe QuestionConcept do
  describe "QuestionConcept#percentage_frequency_for_concept" do
    it "returns the frequency a concept appears compared to all question_concepts" do
      concept = create :concept
      concept2 = create :concept, name: "A different concept", subject: concept.subject
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

  describe "QuestionConcept.concept_count_for_subject" do
    it "returns count of question concepts for subject" do
      subj = create :subject, name: "New Subject"
      concept1 = create :concept, subject: subj
      concept2 = create :concept, subject: subj
      concept3 = create :concept, subject: subj

      create :question_concept, concept: concept1
      create :question_concept, concept: concept2
      create :question_concept, concept: concept3

      different_subject_concept = create :concept
      create :question_concept, concept: different_subject_concept

      expect(QuestionConcept.concept_count_for_subject(subj)).to eq 3
      expect(QuestionConcept.concept_count_for_subject(different_subject_concept.subject)).to eq 1
    end
  end
end
