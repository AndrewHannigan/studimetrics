class Admin::SectionsController < AdminController
  respond_to :html
  inherit_resources
  belongs_to :practice_test

  private

  def permitted_params
    params.permit(:section => [:topic_id, :name])
  end
end