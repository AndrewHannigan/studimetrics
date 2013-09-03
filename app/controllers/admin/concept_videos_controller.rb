class Admin::ConceptVideosController < AdminController
  respond_to :html
  inherit_resources

  private

  def permitted_params
    params.permit(:concept_video => [:video_link, :caption, :concept_id, :pdf])
  end
end
