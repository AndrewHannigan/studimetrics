require 'spec_helper'

describe Topic do
  describe "#subject_name" do
    it "returns the subject name" do
      topic = create :topic

      Subject.any_instance.expects(:name).twice

      expect(topic.subject_name).to eq topic.subject.name
    end
  end
end
