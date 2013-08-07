require 'spec_helper'

feature 'admin manages concept videos' do
  before do
    stub_request(:get, "http://vimeo.com/api/v2/video/123.json").to_return(:status => 200, :body => "[{\"small_thumbnail\":\"asdf\"}]")
  end

  scenario 'adds concept video' do

    admin = create :admin
    concept = create :concept

    visit admin_concept_videos_path as: admin.id

    click_link 'New Concept Video'

    fill_in 'Video ID', with: '123'
    fill_in 'Caption', with: 'A random video √!'
    select concept.name, from: 'Concept'

    click_button 'Create Concept video'

    expect(page).to have_content('Concept video was successfully created.')
  end

  scenario 'edits concept video' do
    admin = create :admin
    concept_video = create :concept_video, video_link: '123'

    visit admin_concept_video_path(concept_video, as: admin.id)
    click_link 'Edit Concept Video'

    fill_in 'Caption', with: 'Yo'

    click_button 'Update Concept video'

    expect(page).to have_content("Concept video was successfully updated.")
  end
end
