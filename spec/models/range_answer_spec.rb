require 'spec_helper'

describe RangeAnswer do

  describe 'validations' do
    it "should be invalid if min is greater than max" do
      answer = FactoryGirl.build(:range_answer, min_value: 10, max_value: 1)

      answer.valid?

      expect(answer.errors.messages[:min_value]).to eq ["can't be greater than the maximum value"]
      expect(answer.errors.messages[:max_value]).to eq ["can't be less than the minimum value"]
    end
  end

  describe "#valid_answer?" do
    it "returns false if the response is not in the range" do
      answer = FactoryGirl.create(:range_answer, min_value: 1, max_value: 10)

      expect(answer.valid_answer?(-1)).to eq false
    end

    it "returns true if the response is in the range" do
      answer = FactoryGirl.create(:range_answer, min_value: 1, max_value: 10)

      expect(answer.valid_answer?(5)).to eq true
    end
  end
end
