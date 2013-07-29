require 'spec_helper'

feature 'user logs in' do

  scenario 'sees college comparison' do
    college = create :college, name: "Indiana University", math: 650, critical_reading: 675, writing: 650
    user = create :user, college: college

    visit profile_path as: user.id

    within "div.college-comparison div.info" do
      expect(page).to have_css "div.average-sat-score div.number", text: "1975"
      expect(page).to have_css "div.average-breakdown-score table tr.reading td.average", text: 675
      expect(page).to have_css "div.average-breakdown-score table tr.math td.average", text: 650
      expect(page).to have_css "div.average-breakdown-score table tr.writing td.average", text: 650
    end
  end

end
