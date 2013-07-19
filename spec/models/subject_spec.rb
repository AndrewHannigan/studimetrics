require 'spec_helper'

describe Subject do
  describe "#acronym" do
    it "returns the first letter of each word capitalized" do
      subj = build :subject, name: "Critical Reading"

      expect(subj.acronym).to eq "CR"
    end

    it "disregards words that start with non-letters" do
      subj = build :subject, name: "Math 1XDJKT 2"

      expect(subj.acronym).to eq "M"
    end

  end
end
