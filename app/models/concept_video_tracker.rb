class ConceptVideoTracker

  attr_accessor :concept_video, :user

  def self.user_has_watched_concept_video?(user, concept_video)
    tracker = ConceptVideoTracker.new concept_video, user
    tracker.videos_watched_by_user.include? concept_video
  end

  def self.users_that_have_watched_concept_video(concept_video)
    tracker = ConceptVideoTracker.new(concept_video, nil)
    tracker.users_that_have_watched_concept_video
  end

  def initialize(concept_video, user)
    self.concept_video = concept_video
    self.user = user
  end

  def track_watch
    REDIS.rpush global_video_users_key, user.id
    REDIS.rpush user_watched_videos_key, concept_video.id
  end

  def videos_watched_by_user
    concept_video_ids = REDIS.lrange user_watched_videos_key, 0, -1
    ConceptVideo.where id: concept_video_ids
  end

  def users_that_have_watched_concept_video
    user_ids = REDIS.lrange global_video_users_key, 0, -1
    User.where id: user_ids
  end

  def number_of_videos_watched_by_user
    REDIS.llen user_watched_videos_key
  end

  def number_of_users_that_have_watched_concept_video
    REDIS.llen global_video_users_key
  end

  private

  def global_video_users_key
    "video:#{concept_video.id}:users"
  end

  def user_watched_videos_key
    "user:#{user.id}:watched_videos"
  end

end
