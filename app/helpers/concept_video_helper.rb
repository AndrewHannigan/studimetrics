module ConceptVideoHelper
  def concept_video_link(concept_video, &block)
    link_data = { behavior: 'video-overlay', video_id: concept_video.id, video_link: concept_video.video_link }

    if current_user.has_watched_concept_video?(concept_video)
      link_class = 'watched'
    else
      link_class = 'unwatched'
    end

    link_to '#', class: link_class, data: link_data, &block
  end
end
