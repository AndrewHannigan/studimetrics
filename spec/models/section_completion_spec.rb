require 'spec_helper'

describe SectionCompletion do
  describe 'auto-defined status scopes' do
    it 'scopes by status' do
      SectionCompletion::STATUS.each do |status|
        create :section_completion, status: status
        expect(SectionCompletion.send(status.underscore).count).to eq(1)
      end
    end
  end

  describe 'auto-defined ? methods' do
    it 'returns true if the status matches the method name' do
      SectionCompletion::STATUS.each do |status|
        completion = create :section_completion, status: status
        expect(completion.send("#{status.underscore}?")).to eq(true)
      end
    end
  end

  describe "#for_section_and_user" do
    it "returns a null section completion object when no section completion exists" do
      section = create :section
      user    = create :user

      section_completion = SectionCompletion.for_section_and_user(section, user)

      expect(section_completion.class).to eq NullSectionCompletion
    end

    it "returns a section completion when one exists" do
      user = create :user
      completion = create :section_completion, user: user
      expect(SectionCompletion.for_section_and_user(completion.section, user).id).to eq(completion.id)
    end
  end

  describe '#in_progress?' do
    it 'returns true if the completion is in-progress' do
      completion = create :section_completion, :in_progress
      completion.should be_in_progress
    end

    it 'returns false if completion is not in-progress' do
      completion = create :section_completion
      completion.should_not be_in_progress
    end
  end

  describe '#complete!' do
    it 'changes the completion status to complete' do
      completion = create :section_completion, :in_progress
      expect {
        completion.complete!
      }.to change{completion.status}.from('In-Progress').to('Completed')
    end
  end

  describe "#total_time" do
    context "when no questions have been answered" do
      it "returns 0" do
        completion = create :section_completion, :in_progress
        expect(completion.total_time).to eq 0
      end
    end

    context "when multiple questions have been answered" do
      it "returns sum of time for each user response" do
        completion = create :section_completion, :in_progress
        section = completion.section
        question = create :question, section: section
        question2 = create :question, section: section

        user_response = create :user_response, section_completion: completion, question: question, time: 50
        user_response2 = create :user_response, section_completion: completion, question: question2, time: 25

        expect(completion.total_time).to eq (user_response.time + user_response2.time)
      end
    end
  end

  describe "#total_correct" do
    context "when there are no user responses" do
      it "returns 0" do
        completion = create :section_completion, :in_progress

        expect(completion.total_correct).to eq 0
      end
    end

    context "when there are only correct responses" do
      it "returns total correct responses" do
        completion = create :section_completion, :in_progress
        section = completion.section
        question = create :question, section: section
        question2 = create :question, section: section

        UserResponse.any_instance.stubs(:correct?).returns(true)

        user_response = create :user_response, section_completion: completion, question: question, correct: true
        user_response2 = create :user_response, section_completion: completion, question: question2, correct: true

        expect(completion.total_correct).to eq 2
      end
    end

    context "when there are both correct and incorrect responses" do
      it "returns only correct responses count" do
        completion = create :section_completion, :in_progress
        section = completion.section
        question = create :question, section: section
        question2 = create :question, section: section

        UserResponse.any_instance.stubs(:correct?).returns(true)
        user_response = create :user_response, section_completion: completion, question: question, correct: true

        UserResponse.any_instance.stubs(:correct?).returns(false)
        user_response2 = create :user_response, section_completion: completion, question: question2, correct: false

        expect(completion.total_correct).to eq 1
      end
    end
  end

  describe "section_questions_count" do
    it "should call section method questions_count" do
      section_completion = create :section_completion
      section_completion.section.expects(:questions_count)

      section_completion.section_questions_count
    end
  end

end
