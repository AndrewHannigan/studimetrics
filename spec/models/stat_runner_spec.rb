require 'spec_helper'

describe StatRunner do
  describe "#peform!" do
    it "calls update! on test_completion if it exists" do
      section_completion = create :section_completion
      stat_runner = StatRunner.new(section_completion)

      section_completion.test_completion.expects(:delay).with(:update!).returns nil

      stat_runner.perform!
    end

    it "does not call update! unless test_completion" do
      section_completion = create :section_completion
      stat_runner = StatRunner.new(section_completion)

      section_completion.test_completion.expects(:delay).with(:update!).never
      stat_runner.expects(:test_completion).returns(nil)

      stat_runner.perform!
    end
  end
end
