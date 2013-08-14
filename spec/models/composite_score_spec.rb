require 'spec_helper'

describe CompositeScore do

  describe "CompositeScore#projected_total_score_for_user" do
    it "returns nil if any subject doesn't have a composite score for user" do
      user = create :user
      subj = create :subject
      subject_without_composite_score = create :subject

      composite_score = create :composite_score, user: user, subject: subj

      expect(CompositeScore.projected_total_score_for_user(user)).to eq nil
    end

    it "returns the sum of the composite scores" do
      user = create :user
      subj = create :subject
      subj2 = create :subject

      composite_score = create :composite_score, user: user, subject: subj
      composite_score2 = create :composite_score, user:user, subject: subj2

      CompositeScore.any_instance.stubs(:projected_score).returns(500)
      expect(CompositeScore.projected_total_score_for_user(user)).to eq (composite_score.projected_score + composite_score2.projected_score)
    end
  end

  describe "CompositeScore#projected_score_for_user_and_subject" do
    context "subject is a string" do
      it "returns project score" do
        user = create :user
        subj = create :subject, name: "Math"
        composite_score = create :composite_score, subject: subj, user: user
        CompositeScore.any_instance.expects(:projected_score).returns(500)

        expect(CompositeScore.projected_score_for_user_and_subject(user, "Math")).to eq 500
      end
    end

  end

  describe "#calculated_composite_score" do
    it "returns score according to formula" do
      subj = create :subject, name: "Math"
      concept = create :concept, name: "Algrebra", subject: subj
      concept2 = create :concept, name: "Geometry", subject: subj
      user = create :user
      composite_score = CompositeScore.new(subject: subj, user: user)

      QuestionConcept.stubs(:percentage_frequency_for_concept).with(concept.id).returns(0.25)
      QuestionConcept.stubs(:percentage_frequency_for_concept).with(concept2.id).returns(0.75)
      composite_score.stubs(:accuracy_for_concept).with(concept.id).returns(0.50)
      composite_score.stubs(:accuracy_for_concept).with(concept2.id).returns(0.20)
      composite_score.stubs(:concept_ids_with_responses).returns([concept.id, concept2.id])

      expect(composite_score.calculated_composite_score).to eq 5.062500000000002
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
