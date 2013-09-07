require 'spec_helper'

describe Statistic do
  describe "#accuracy_for_subject_per_section_completion" do
    context "when the user has not completed any section completions" do
      it "should return an empty array" do
        user = create :user
        math = create :subject, name: "Math"

        statistic = Statistic.new(user)

        expect(statistic.accuracy_for_subject_per_section_completion(math)).to eq []
      end
    end

    context "when the user has completed a section completion" do
      it "returns an array of accuracy for the given subject" do
        user = create :user
        math = create :subject, name: "Math"
        section_completion = create :section_completion, :completed, user: user, scoreable: true

        statistic = Statistic.new(user)
        SectionCompletion.any_instance.stubs(:accuracy).returns(50.0)

        expect(statistic.accuracy_for_subject_per_section_completion(math)).to eq [50.0]
      end
    end

    context "when the user has 1 incomplete and 0 completed section completions" do
      it "returns an empty array" do
        user = create :user
        math = create :subject, name: "Math"
        section_completion = create :section_completion, user: user, scoreable: false, status: "Not Started"

        statistic = Statistic.new(user)

        expect(statistic.accuracy_for_subject_per_section_completion(math)).to eq []
      end
    end
  end
end
