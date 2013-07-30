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

  describe "#question_count_per_column" do
    it 'returns the number of questions to be used in each column' do
      section = create :section
      create_list :question, 2, section: section

      expect(section.question_count_per_column).to eq(1)
      create :question, section: section
      expect(section.question_count_per_column).to eq(1)
      create :question, section: section
      expect(section.question_count_per_column).to eq(2)
    end

    it 'returns 1 if only 1 question' do
      question = create :question
      expect(question.section.question_count_per_column).to eq(1)
    end
  end
end
