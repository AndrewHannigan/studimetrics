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

end
