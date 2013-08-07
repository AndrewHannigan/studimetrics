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
        section_completion = user_response.section_completion
        section_completion.in_progress!
        last_activity = LastActivity.new(user: user_response.section_completion.user, practice_test: user_response.section_completion.practice_test)

        expect(last_activity.section).to eq user_response.section_completion.section
      end
    end

    context "when the user starts two sections and then answers a question on the first section started" do
      it "returns the last section that had a question answered" do
        user_response = create :user_response
        section_completion = user_response.section_completion
        section_completion.in_progress!
        user = section_completion.user
        practice_test = section_completion.practice_test

        section = create :section, practice_test: practice_test
        section_completion2 = create :section_completion, section_id: section.id, user: user
        section_completion2.in_progress!

        question = create :question, section: section_completion.section
        user_response = UserResponse.create(question: question, value: "A", correct: true, time: 100, section_completion: section_completion)
        last_activity = LastActivity.new(user: user)

        expect(last_activity.section).to eq section_completion.section

      end
    end
  end
end
