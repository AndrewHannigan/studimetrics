require 'spec_helper'

describe MultipleChoiceAnswer do
  describe "#valid_answer?" do
    it "returns false if the value does not match" do
      answer = FactoryGirl.create :multiple_choice_answer, value: "A"

      expect(answer.valid_answer?("B")).to eq false
    end

    it "returns true if the value does match" do
      answer = FactoryGirl.create :multiple_choice_answer, value: "A"

      expect(answer.valid_answer?("A")).to eq true
    end
  end

  describe "#answer" do
    it "returns the same value as the value field" do
      answer = MultipleChoiceAnswer.new(value: "A")

      expect(answer.answer).to eq answer.value

    end
  end

end
