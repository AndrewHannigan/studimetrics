require 'spec_helper'

feature 'user views concept videos' do
  scenario 'when there are none' do
    user = create :user
    create :concept

    visit concepts_path as: user.id

    expect(page).to have_content('No videos yet.')
  end

  scenario 'navigates to and views a video', js: true do
    Vimeo::Simple::Video.stubs(:info).returns(OpenStruct.new(parsed_response: ["thumbnail_large" => 'http://fake.png']))
    user = create :user
    concept = create :concept, name: 'wack', description: "So Wack"
    concept_video = create :concept_video, video_link: '123', concept: concept

    visit concepts_path as: user.id

    click_link 'wack'

    expect(page).to have_css('h4', text: "So Wack")

    video_on_page(concept_video).click

    within video_modal_on_page do
      expect(page).to have_css('iframe')
    end
  end

  scenario 'sees indicator for unwatched', js: true do
    Vimeo::Simple::Video.stubs(:info).returns(OpenStruct.new(parsed_response: ["thumbnail_large" => 'http://fake.png']))
    User.any_instance.stubs(:has_watched_concept_video?).returns(false)
    user = create :user
    concept_video = create :concept_video, video_link: '123'

    visit concepts_path as: user.id

    the_video = video_on_page concept_video
    # using page since for some reason returned link doesnt have class...
    expect(page).to have_css '.unwatched'

    the_video.click

    expect(page).to_not have_css '.unwatched'
  end
end

def video_on_page(concept_video)
  page.find("a[data-video-link='#{concept_video.video_link}']")
end

def video_modal_on_page
  page.find("#concept-video-modal")
end
