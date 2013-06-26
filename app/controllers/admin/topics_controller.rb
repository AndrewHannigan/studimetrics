class Admin::TopicsController < AdminController
  respond_to :html
  inherit_resources

  private

  def permitted_params
    params.permit(:topic => [:name])
  end
end
