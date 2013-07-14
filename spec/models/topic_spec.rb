require 'spec_helper'

describe Topic do
  describe "#subject_name" do
    it "returns the subject name" do
      subject = Subject.new name: 'Math'
      topic = Topic.new subject: subject

      expect(topic.subject_name).to eq 'Math'
    end
  end
end
