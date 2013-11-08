require 'spec_helper'

feature 'User changes sat date' do
  scenario 'with no sat date set' do
    pending 'date issue'

    Timecop.travel Time.local(2013, 7, 15) do
      user = create :user
      visit profile_path as: user.id

      change_sat_link_on_page.click

      select '11/02/2013', from: 'Date'

      click_button 'Save'

      expect(page).to have_css '.date h3', text: 'Nov 2nd'
      expect(page).to have_css '.date .year', text: '2013'
    end
  end
end

def change_sat_link_on_page
  page.find('#change-sat-date')
end
