require 'spec_helper'

feature 'user sees test history on profile' do
  scenario 'with no test completions' do
    user = create :user
    visit profile_path as: user.id
    expect(page).to have_content(I18n.t 'profile.graph_demo_text')
  end

  scenario 'with test completions' do
    user = create :user
    create :test_completion, user: user, percentage_complete: 100
    visit profile_path as: user.id
    expect(page).to have_css('#test-graph')
  end
end
