require 'spec_helper'

feature 'user sees college comparison on profile' do

  scenario 'changes with autocomplete', js: true do
    pending 'autocomplete not populating'
    college = create :college, name: "Indiana University"
    College.any_instance.stubs(:average_critical_reading).returns(100)
    College.any_instance.stubs(:average_math).returns(200)
    College.any_instance.stubs(:average_writing).returns(300)
    College.any_instance.stubs(:average_score).returns(1000)
    new_college = create :college, name: "Duke"
    user = create :user, college: college

    visit profile_path as: user.id

    within "div.college-comparison" do
      expect(page).to have_content 'Indiana University'
      expect(page).to have_css ".average-sat-score div.number", text: 1000
      expect(page).to have_css ".reading .average", text: 100
      expect(page).to have_css ".math .average", text: 200
      expect(page).to have_css ".writing .average", text: 300

      click_link 'change'
    end

    fill_in 'Selected college', with: 'Du'
    sleep(1)
    college_on_page(new_college).click

    click_button 'Save'

    within ".college-comparison" do
      expect(page).to have_content 'Duke'
    end
  end

end

def college_on_page(college)
  page.find("[data-id='college-#{college.id}']")
end
