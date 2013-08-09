require 'spec_helper'

describe NextSection do
  describe "NextSection#for_practice_test_and_user" do
    context "when the user has a section that is in-progress" do
      it "returns in-progress section" do
        user = create :user
        section_completion = create :section_completion, status: "In-Progress", user: user

        section = create :section, practice_test: section_completion.practice_test

        completed_section_completion = create :section_completion, user: user, status: "Completed", section: section, test_completion: section_completion.test_completion

        section = NextSection.for_practice_test_and_user(section.practice_test, user)

        NextSection.expects(:lowest_section_not_started_for_test_run).never
        expect(section).to eq section_completion.section
      end
    end

    context "when the user has a section that has not been started" do
      it "returns the not started section" do
        user = create :user
        section_completion = create :section_completion, status: "Not Started", user: user

        section = create :section, practice_test: section_completion.practice_test

        completed_section_completion = create :section_completion, user: user, status: "Completed", section: section, test_completion: section_completion.test_completion

        section = NextSection.for_practice_test_and_user(section.practice_test, user)

        expect(section).to eq section_completion.section
      end
    end

    context "when the user has a section that is in progress and not started" do
      it "returns the in progress section" do
        user = create :user
        section_completion = create :section_completion, status: "Not Started", user: user
        test_completion = section_completion.reload.test_completion

        section = create :section, practice_test: section_completion.practice_test

        completed_section_completion = create :section_completion, user: user, status: "Completed", section: section, test_completion: test_completion

        section2 = create :section, practice_test: section_completion.practice_test
        in_progress_section_completion = create :section_completion, user: user, status: "In-Progress", section: section2, test_completion: test_completion

        section = NextSection.for_practice_test_and_user(completed_section_completion.section.practice_test, user)

        expect(section).to eq in_progress_section_completion.section

      end
    end
  end

end
