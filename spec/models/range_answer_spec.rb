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

    it 'converts the response to a float for comparison' do
      answer = build :range_answer, min_value: 5, max_value: 6

      expect(answer.valid_answer?('5.23')).to eq true
    end

  end

  describe "#answer" do
    it "returns a string representation of the min/max range" do
      answer = FactoryGirl.create :range_answer, min_value: 1, max_value: 10

      expect(answer.answer).to eq "1.0-10.0"
    end
  end

  describe "validations" do
    it "returns error if the value is > 4 characters" do
      answer = FactoryGirl.build :range_answer, min_value: "12345", max_value:"12345"
      answer.valid?

      expect(answer.errors[:min_value]).to eq ["4 characters is the maximum allowed"]
      expect(answer.errors[:max_value]).to eq ["4 characters is the maximum allowed"]
    end
  end
end
