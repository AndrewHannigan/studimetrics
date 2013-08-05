require 'spec_helper'

describe College do
  it_behaves_like "a profile image"

  describe "#average_score" do
    it "sums the average scores for each subject" do
      college = College.new
      college.stubs(:average_math).returns(100)
      college.stubs(:average_critical_reading).returns(100)
      college.stubs(:average_writing).returns(100)

      expect(college.average_score).to eq 300
    end
  end

  describe '#average_math' do
    it 'returns the average for high and low math percentiles' do
      college = College.new low_percentile_math: 200, high_percentile_math: 400

      expect(college.average_math).to eq 300
    end
  end

  describe '#average_critical_reading' do
    it 'returns the average for high and low critical_reading percentiles' do
      college = College.new low_percentile_critical_reading: 200, high_percentile_critical_reading: 400

      expect(college.average_critical_reading).to eq 300
    end
  end

  describe '#average_math' do
    it 'returns the average for high and low writing percentiles' do
      college = College.new low_percentile_writing: 200, high_percentile_writing: 400

      expect(college.average_writing).to eq 300
    end
  end
end
