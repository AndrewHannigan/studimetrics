require 'spec_helper'

describe TestCompletion do
  describe "#retake_available?" do
    it "returns true if percentage is 100" do
      test_completion = TestCompletion.new(percentage_complete: 100)

      expect(test_completion.retake_available?).to eq true
    end

    it "returns false if percentage is less than 100" do
      test_completion = TestCompletion.new(percentage_complete: 99)

      expect(test_completion.retake_available?).to eq false
    end
  end

  describe "#math_score" do
    it "returns the score post conversion" do
      test_completion = TestCompletion.new(raw_math_score: 5, percentage_complete: 100)
      ConversionTable.expects(:converted_score).with("M", 5).returns(200)

      expect(test_completion.math_score).to eq 200
    end
  end

  describe "#critical_reading_score" do
    it "returns the score post conversion" do
      test_completion = TestCompletion.new(raw_critical_reading_score: 5, percentage_complete: 100)
      ConversionTable.expects(:converted_score).with("CR", 5).returns(200)

      expect(test_completion.critical_reading_score).to eq 200
    end
  end

  describe "#writing_score" do
    it "returns the score post conversion" do
      test_completion = TestCompletion.new(raw_writing_score: 5, percentage_complete: 100)
      ConversionTable.expects(:converted_score).with("W", 5).returns(200)

      expect(test_completion.writing_score).to eq 200
    end
  end

  describe "#update!" do
    it "fills in raw scores if the test is complete" do
      test_completion = create :test_completion

      test_completion.stubs(:percentage_complete).returns(100)
      test_completion.expects(:total_questions).returns(100).twice
      test_completion.expects(:collect_and_update_raw_scores)

      test_completion.update!
    end

    it "does not fill in raw scores if test is incomplete" do
      test_completion = create :test_completion

      test_completion.stubs(:percentage_complete).returns(50)
      test_completion.expects(:total_questions).returns(50).twice
      test_completion.expects(:collect_and_update_raw_scores).never

      test_completion.update!
    end

    it "calls update_percentage_complete" do
      test_completion = create :test_completion

      test_completion.expects(:total_questions).returns(100).twice
      test_completion.expects(:total_responses).returns(50)

      test_completion.update!
      expect(test_completion.percentage_complete).to eq 50.0
    end
  end

end
