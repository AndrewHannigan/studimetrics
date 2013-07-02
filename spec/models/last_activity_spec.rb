require 'spec_helper'

describe LastActivity do
  describe "#section" do
    context "when the user has not started any sections" do
      it "should return nil" do
        user = create :user
        section = create :section
        last_activity = LastActivity.new(user: user, practice_test: section.practice_test)

        expect(last_activity.section).to eq nil
      end
    end

    context "when the user has started one section" do
      it "should return the section that had been started" do
        user_response = create :user_response
        last_activity = LastActivity.new(user: user_response.section_completion.user, practice_test: user_response.section_completion.section.practice_test)

        expect(last_activity.section).to eq user_response.section_completion.section
      end
    end

    context "when the user has completed one section and not started another" do
      it "should return nil" do
        user_response = create :user_response
        section_completion = user_response.section_completion
        section_completion.update_attributes!(status: "Completed")
        last_activity = LastActivity.new(user: user_response.section_completion.user, practice_test: section_completion.section.practice_test)

        expect(last_activity.section).to eq nil
      end
    end
  end
end
