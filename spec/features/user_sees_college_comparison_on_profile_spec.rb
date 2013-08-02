require 'spec_helper'

feature 'user logs in' do

  scenario 'sees college comparison' do
    college = create :college, name: "Indiana University", math: 650, critical_reading: 675, writing: 650
    create :college, name: "Duke", math: 200, critical_reading: 200, writing: 200
    user = create :user, college: college

    visit profile_path as: user.id

    within "div.college-comparison" do
      expect(page).to have_content 'Indiana University'
      expect(page).to have_css ".average-sat-score div.number", text: "1975"
      expect(page).to have_css ".reading .average", text: 675
      expect(page).to have_css ".math .average", text: 650
      expect(page).to have_css ".writing .average", text: 650

      click_link 'change'
    end

    select 'Duke', from: 'Selected college'
    click_button 'Save'

    within ".college-comparison" do
      expect(page).to have_content 'Duke'
    end
  end

end
