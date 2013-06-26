require 'spec_helper'

describe Question do
  describe 'validations' do
    it 'must have a unique name per section id' do
     question = FactoryGirl.create :question
     expect {
      FactoryGirl.create! :question, section: question.section
     }.to raise_error
    end
  end

  describe "#answer_class" do
    it "should be a class based on question_type" do
      question = Question.new(question_type: "Range")

      expect(question.answer_class).to eq RangeAnswer
    end
  end

  describe '#answer_association_name' do
    it 'returns the underscored answer association' do
      question = Question.new question_type: 'Multiple Choice'
      expect(question.answer_association_name).to eq 'multiple_choice_answers'
    end
  end

  describe '#answers' do
    Question::QUESTION_TYPES.each do |type|
      it "returns answers when type is #{type}" do
        question = FactoryGirl.create :question, question_type: type
        answer = FactoryGirl.create question.answer_class.name.underscore.to_sym, question_id: question.id

        expect(question.answers).to eq [answer]
      end
   end
  end


  describe "#valid_answer?" do
    context "RangeAnswer" do
      it "calls valid_answer? on the associated answers" do
        question = FactoryGirl.create :question, question_type: "Range"
        answer = FactoryGirl.create :range_answer, min_value: 1, max_value: 10, question_id: question.id
        question.answer_class.any_instance.expects(:valid_answer?).with(5).once

        question.valid_answer?(5)
      end

      it "calls valid_answer? on the associated answers" do
        question = FactoryGirl.create :question, question_type: "Range"
        2.times {answer = FactoryGirl.create :range_answer, min_value: 1, max_value: 10, question_id: question.id}
        question.answer_class.any_instance.expects(:valid_answer?).with(5).twice

        question.valid_answer?(5)
      end
    end

  end
end

