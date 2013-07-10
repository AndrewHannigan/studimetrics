require 'spec_helper'

describe Section do
  describe 'validations' do
    it 'must have a unique name per practice test id' do
     section = FactoryGirl.create :section
     expect {
      FactoryGirl.create! :section, practice_test: section.practice_test
     }.to raise_error
    end
  end

  describe "#questions_count" do
    it "should equal number of questions for section" do
      question = create :question
      section = question.section

      expect(section.questions_count).to eq section.questions.count
    end
  end
end
