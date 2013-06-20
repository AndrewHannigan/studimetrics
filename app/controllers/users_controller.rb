class UsersController < Clearance::UsersController

  private

  def allowed_user_params
    params[:user].permit(:first_name, :last_name, :email, :password, :grade, :city, :state)
  end

  def user_from_params
    Clearance.configuration.user_model.new(allowed_user_params)
  end
end
