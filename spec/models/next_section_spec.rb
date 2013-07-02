require 'spec_helper'

describe NextSection do
  describe "#section" do
    context "when the user has not started any sections" do
      it "should return nil" do
        user = create :user
        practice_test = create :practice_test
        2.times {create(:section, practice_test: practice_test)}
        next_activity = NextSection.new(user: user, practice_test: practice_test)

        expect(next_activity.section).to eq practice_test.sections.order("number asc").first
      end
    end

    context "when the user has started one section" do
      it "should return the section that had been started" do
        user_response = create :user_response
        next_activity = NextSection.new(user: user_response.section_completion.user, practice_test: user_response.section_completion.section.practice_test)

        expect(next_activity.section).to eq user_response.section_completion.section
      end
    end

    context "when the user has completed one section and not started another" do
      it "should return the next unstarted section" do
        user_response = create :user_response
        section_completion = user_response.section_completion
        section_completion.update_attributes!(status: "Completed")

        second_section = create :section, practice_test: section_completion.section.practice_test
        next_activity = NextSection.new(user: user_response.section_completion.user, practice_test: section_completion.section.practice_test)

        expect(next_activity.section).to eq second_section
      end
    end

    context "when the user has completed all sections and is retaking the test" do
      context "with no sections started again" do
        it "should return the first section" do
          user_response = create :user_response
          first_section_completion = user_response.section_completion
          second_section = create :section, practice_test: user_response.section_completion.section.practice_test
          second_section_completion = create :section_completion, section: second_section, user: user_response.section_completion.user
          first_section_completion.update_attributes!(status: "Completed")
          second_section_completion.update_attributes!(status: "Completed")

          next_activity = NextSection.new(user: user_response.section_completion.user, practice_test: user_response.section_completion.section.practice_test)

          expect(next_activity.section).to eq user_response.section_completion.section

        end
      end

      context "with one section completed twice" do
        it "should return the second section" do
          user_response = create :user_response
          first_section_completion = user_response.section_completion
          second_section = create :section, practice_test: user_response.section_completion.section.practice_test
          second_section_completion = create :section_completion, section: second_section, user: user_response.section_completion.user
          first_section_completion.update_attributes!(status: "Completed")
          second_section_completion.update_attributes!(status: "Completed")

          repeat_first_section = first_section_completion.dup.save!
          next_activity = NextSection.new(user: user_response.section_completion.user, practice_test: user_response.section_completion.section.practice_test)

          expect(next_activity.section).to eq second_section
        end
      end
    end
  end
end
