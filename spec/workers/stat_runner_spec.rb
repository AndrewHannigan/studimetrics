require 'spec_helper'

describe StatRunner do
  describe "#peform" do
    it "calls update! on test_completion if it exists" do
      section_completion = create :section_completion, scoreable: true

      TestCompletion.any_instance.expects(:update!).returns nil
      CompositeScore.any_instance.expects(:update!).returns nil

      stat_runner = StatRunner.new
      stat_runner.perform(section_completion.id)
    end

    it "does not call update! unless test_completion" do
      section_completion = create :section_completion, scoreable: false
      stat_runner = StatRunner.new

      section_completion.send(:test_completion).expects(:update!).never
      stat_runner.expects(:test_completion).returns(nil)

      stat_runner.perform(section_completion.id)
    end

    it "creates skipped responses if not all questions are answered" do
      section_completion = create :section_completion, scoreable: true
      question = create :question, section: section_completion.section

      stat_runner = StatRunner.new

      expect{stat_runner.perform(section_completion.id)}.to change{UserResponse.count}.from(0).to(1)
    end
  end
end
