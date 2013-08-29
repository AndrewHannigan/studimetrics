class Admin::ConceptsController < AdminController
  respond_to :html
  inherit_resources

  def index
    @concepts = Concept.order(:name)
    index!
  end

  private

  def permitted_params
    params.permit(:concept => [:name, :subject_id, :description])
  end
end
