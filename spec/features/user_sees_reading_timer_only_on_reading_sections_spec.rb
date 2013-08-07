require 'spec_helper'

feature "User taking practice test" do
  context "when viewing a reading section" do
    it "displays the reading timer", js: true do
      user = create :user

      User.any_instance.stubs(:has_responses?).returns(true)

      subj = create :subject, name: "Critical Reading"
      section = create :section, subject: subj

      visit practice_tests_path as: user.id

      section_link_on_page(section).click

      click_link "section-play-button"

      expect(page).to have_css("#critical-reading-timer-button")
    end
  end

  context "when viewing a non-reading section" do
    it "does not display the reading timer", js: true do
      user = create :user

      User.any_instance.stubs(:has_responses?).returns(true)

      subj = create :subject, name: "Writing"
      section = create :section, subject: subj

      visit practice_tests_path as: user.id

      section_link_on_page(section).click

      click_link "section-play-button"

      expect(page).to_not have_css("#critical-reading-timer-button")
    end
  end
end
