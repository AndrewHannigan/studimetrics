require 'spec_helper'

describe Statistic do

  describe "#next_available_section_for_subject" do
    context "when a section is available in the current practice test for the user" do
      it "returns the available section in the given subject" do
        user = create :user
        subj = create :subject, name: "Math"
        section = create :section, subject: subj

        Statistic.any_instance.stubs(:target_subject).returns(subj)
        statistic = Statistic.new(user)

        expect(statistic.next_available_section_for_target_subject).to eq section.id
      end
    end

    context "when a section is available but not in the current practice test" do
      it "returns the available section in the next practice test" do
        user = create :user
        subj = create :subject, name: "Math"
        section = create :section, subject: subj
        create :section_completion, :completed, user: user, section: section, scoreable: true

        section2 = create :section, subject: subj

        Statistic.any_instance.stubs(:target_subject).returns(subj)
        statistic = Statistic.new(user)

        expect(user.current_test).to eq section.practice_test
        expect(statistic.next_available_section_for_target_subject).to eq section2.id
      end
    end

    context "when no section is incomplete for the given subject and user" do
      it "returns nil" do
        user = create :user
        subj = create :subject, name: "Math"
        section = create :section, subject: subj
        create :section_completion, :completed, user: user, section: section, scoreable: true

        Statistic.any_instance.stubs(:target_subject).returns(subj)
        statistic = Statistic.new(user)

        expect(statistic.next_available_section_for_target_subject).to eq nil
      end
    end
  end

  describe "#target_subject" do
    it "returns the subject with the lowest composite score for the user" do
      user = create :user
      math = create :subject, name: "Math"
      reading = create :subject, name: "Reading"
      writing = create :subject, name: "Writing"

      create :composite_score, user: user, subject: math, composite_score: 0.0
      create :composite_score, user: user, subject: reading, composite_score: 10.0
      create :composite_score, user: user, subject: writing, composite_score: 20.0

      statistic = Statistic.new(user)

      expect(statistic.target_subject).to eq math
    end
  end

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
