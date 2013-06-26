class Admin::SubjectsController < AdminController
  respond_to :html
  inherit_resources

  private

  def permitted_params
    params.permit(:subject => [:name])
  end
end
