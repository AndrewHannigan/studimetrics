class Admin::UsersController < AdminController
  respond_to :html
  inherit_resources

  private

  def permitted_params
    params.permit(user: [:first_name, :last_name, :email, :password, :grade, :city, :state, :admin])
  end

end
