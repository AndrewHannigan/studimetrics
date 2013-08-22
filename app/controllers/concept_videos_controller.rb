class ConceptVideosController < ApplicationController
  def track
    concept_video = ConceptVideo.find params[:id]
    concept_video_tracker = ConceptVideoTracker.new concept_video, current_user
    concept_video_tracker.track_watch
    render nothing: true
  end
end
