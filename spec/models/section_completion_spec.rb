require 'spec_helper'

describe SectionCompletion do
  describe "validations" do
    it "returns error if the status is invalid" do
      section_completion = SectionCompletion.new(status: "Not Awesome")
      section_completion.valid?

      expect(section_completion.errors[:status]).to eq ["Valid statuses are: #{SectionCompletion::STATUS.to_sentence}"]
    end
  end
end
