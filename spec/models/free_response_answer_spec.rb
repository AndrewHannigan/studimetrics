require 'spec_helper'

describe FreeResponseAnswer do
  describe "#valid_answer?" do
    it "returns false if the value does not match" do
      answer = FactoryGirl.create :free_response_answer, value: "A"

      expect(answer.valid_answer?("B")).to eq false
    end

    it "returns true if the value does match" do
      answer = FactoryGirl.create :free_response_answer, value: "A"

      expect(answer.valid_answer?("A")).to eq true
    end
  end

  describe "validations" do
    it "returns error if the value is > 4 characters" do
      answer = FactoryGirl.build :free_response_answer, value: "12345"
      answer.valid?

      expect(answer.errors[:value]).to eq ["4 characters is the maximum allowed"]
    end
  end
end

