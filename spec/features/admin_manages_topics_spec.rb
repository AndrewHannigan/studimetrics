require 'spec_helper'

feature 'Admin manages topics' do
  scenario 'adds topic' do
    admin = FactoryGirl.create :admin
    subj = create  :subject

    visit admin_topics_path as: admin.id

    click_link 'New Topic'

    fill_in 'Name', with: 'Cool Topic'
    select subj.name, from: 'Subject'

    click_button 'Create Topic'

    expect(page).to have_content("Topic was successfully created.")
  end

  scenario 'edits topic' do
    admin = FactoryGirl.create :admin
    topic = FactoryGirl.create :topic

    visit admin_topic_path(topic, as: admin.id)
    click_link 'Edit Topic'

    fill_in 'Name', with: 'Cooler Topic'

    click_button 'Update Topic'

    expect(page).to have_content("Topic was successfully updated.")
  end
end
