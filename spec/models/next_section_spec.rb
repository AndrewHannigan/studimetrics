require 'spec_helper'

describe NextSection do
  describe "#for_user_and_practice_test" do
    context "when the user has not started any sections" do
      it "should return nil" do
        user = create :user
        practice_test = create :practice_test
        2.times {create(:section, practice_test: practice_test)}
        next_section = NextSection.for_user_and_practice_test user, practice_test

        expect(next_section).to eq practice_test.sections.order("number asc").first
      end
    end

    context "when the user has started one section" do
      it "should return the section that had been started" do
        user_response = create :user_response
        next_section = NextSection.for_user_and_practice_test user_response.section_completion.user, user_response.section_completion.practice_test

        expect(next_section).to eq user_response.section_completion.section
      end
    end

    context "when the user has completed one section and not started another" do
      it "should return the next unstarted section" do
        user_response = create :user_response
        section_completion = user_response.section_completion
        section_completion.update_attributes!(status: "Completed")

        second_section = create :section, practice_test: section_completion.section.practice_test
        next_section = NextSection.for_user_and_practice_test user_response.section_completion.user, user_response.section_completion.practice_test

        expect(next_section).to eq second_section
      end
    end

    context "when the user has completed all sections and is retaking the test" do
      context "with no sections started again" do
        it "should return the first section" do
          user_response = create :user_response
          first_section_completion = user_response.section_completion
          second_section = create :section, practice_test: user_response.section_completion.practice_test
          second_section_completion = create :section_completion, section: second_section, user: user_response.section_completion.user
          first_section_completion.update_attributes!(status: "Completed")
          second_section_completion.update_attributes!(status: "Completed")

          next_section = NextSection.for_user_and_practice_test user_response.section_completion.user, user_response.section_completion.practice_test

          expect(next_section).to eq user_response.section_completion.section

        end
      end

      context "with one section completed twice" do
        it "should return the second section" do
          user_response = create :user_response
          first_section_completion = user_response.section_completion
          second_section = create :section, practice_test: user_response.section_completion.practice_test
          second_section_completion = create :section_completion, section: second_section, user: user_response.section_completion.user
          first_section_completion.update_attributes!(status: "Completed")
          second_section_completion.update_attributes!(status: "Completed")

          repeat_first_section = first_section_completion.dup.save!
          next_section = NextSection.for_user_and_practice_test user_response.section_completion.user, user_response.section_completion.practice_test

        end
      end
    end
  end

  describe '.for_current_section' do
    it 'returns the next lowest number' do
      practice_test = create :practice_test
      sections = create_list :section, 2, practice_test: practice_test
      next_section = NextSection.for_current_section sections.first

      expect(next_section).to eq(sections.last)
    end

    it 'returns the lowest number in the test if there is not another' do
      practice_test = create :practice_test
      sections = create_list :section, 2, practice_test: practice_test
      next_section = NextSection.for_current_section sections.last

      expect(next_section).to eq(sections.first)
    end
  end
end
