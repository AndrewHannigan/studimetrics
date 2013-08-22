require 'spec_helper'

describe ConceptVideoHelper do
  describe '#concept_video_link' do
    it 'generates a link with a class of unwatched' do
      concept_video = ConceptVideo.new video_link: '123'
      helper.stubs(:current_user).returns NullUser.new

      expect(helper.concept_video_link(concept_video){|a| 'asdf'}).to include 'class="unwatched"'
    end
  end
end
