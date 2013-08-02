require 'spec_helper'

describe College do
  it_behaves_like "a profile image"

  describe "#average" do
    it "sums the average scores for each subject" do
      college = College.new(math: 200, critical_reading: 300, writing: 600)

      expect(college.average_score).to eq 1100
    end
  end
end
