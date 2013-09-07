require 'spec_helper'

feature 'user views accuracy graph' do
  scenario 'with no section completions' do
    user = create :user
    visit profile_path as: user.id
    expect(page).to have_content(I18n.t 'profile.accuracy_graph_demo_text')
  end

  scenario 'shows a graph for each subject if there is at least 1 completed' do
    user = create :user

    subj = create :subject, name: "Math"
    subj = create :subject, name: "Reading"
    subj = create :subject, name: "Writing"

    create :section_completion, :completed, user: user
    visit profile_path as: user.id

    expect(page).to have_css('.accuracy-graph', count: 3)
  end
end
