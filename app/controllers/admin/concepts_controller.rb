class Admin::ConceptsController < AdminController
  respond_to :html
  inherit_resources

  private

  def permitted_params
    params.permit(:concept => [:name, :subject_id, :description])
  end
end
