require 'spec_helper'

describe ConceptVideo do
  %w(large medium small).each do |size|
    describe "##{size}_thumbnail" do
      it 'returns a thumbnail url' do
        Vimeo::Simple::Video.stubs(:info).returns(OpenStruct.new(parsed_response: ["thumbnail_#{size}" => 'http://fake.png']))

        concept_video = ConceptVideo.new video_link: '123'
        expect(concept_video.send("#{size}_thumbnail")).to eq 'http://fake.png'
      end
    end
  end
end
