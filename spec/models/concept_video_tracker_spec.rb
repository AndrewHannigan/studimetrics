require 'spec_helper'

describe ConceptVideoTracker do
  describe '.user_has_watched_concept_video?' do
    it 'returns true if the user has watched the video' do
      user = build_stubbed :user
      concept_video = build_stubbed :concept_video
      ConceptVideoTracker.any_instance.expects(:videos_watched_by_user).returns([concept_video])
      expect(ConceptVideoTracker.user_has_watched_concept_video?(user, concept_video)).to eq true
    end
  end

  describe '.users_that_have_watched_concept_video' do
    it 'creates a new instance and calls users_that_have_watched_video' do
      ConceptVideoTracker.any_instance.expects(:users_that_have_watched_concept_video)
      concept_video = build_stubbed :concept_video

      ConceptVideoTracker.users_that_have_watched_concept_video(concept_video)
    end
  end

  describe '#track_watch' do
    it 'tracks a watch' do
      user = build_stubbed :user
      concept_video = build_stubbed :concept_video
      concept_video_tracker = ConceptVideoTracker.new concept_video, user

      expect {
        concept_video_tracker.track_watch
      }.to change{ concept_video_tracker.number_of_videos_watched_by_user }.from(0).to(1)
    end

    it 'adds the user to the global watch list for the video' do
      user = build_stubbed :user
      concept_video = build_stubbed :concept_video
      concept_video_tracker = ConceptVideoTracker.new concept_video, user

      expect {
        concept_video_tracker.track_watch
      }.to change{concept_video_tracker.number_of_users_that_have_watched_concept_video}.from(0).to(1)
    end
  end

  describe '#videos_watched_by_user' do
    it 'returns all videos watched' do
      user = build_stubbed :user
      concept_video = create :concept_video
      concept_video_tracker = ConceptVideoTracker.new concept_video, user
      concept_video_tracker.track_watch

      expect(concept_video_tracker.videos_watched_by_user).to include concept_video
    end
  end

  describe '#users_that_have_watched_concept_video' do
    it 'returns all the users' do
      user = create :user
      concept_video = build_stubbed :concept_video
      concept_video_tracker = ConceptVideoTracker.new concept_video, user
      concept_video_tracker.track_watch

      expect(concept_video_tracker.users_that_have_watched_concept_video).to include user
    end
  end

  describe '#number_of_videos_watched_by_user' do
    it 'returns the count' do
      user = build_stubbed :user
      concept_video = build_stubbed :concept_video
      concept_video_tracker = ConceptVideoTracker.new concept_video, user
      concept_video_tracker.track_watch

      expect(concept_video_tracker.number_of_videos_watched_by_user).to eq 1
    end
  end

  describe '#number_of_users_that_have_watched_concept_video' do
    it 'returns the count' do
      user = build_stubbed :user
      concept_video = build_stubbed :concept_video
      concept_video_tracker = ConceptVideoTracker.new concept_video, user
      concept_video_tracker.track_watch

      expect(concept_video_tracker.number_of_users_that_have_watched_concept_video).to eq 1
    end
  end
end
