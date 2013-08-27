class UsersController < Clearance::UsersController

  def deactivate
    if current_user.deactivate!
      sign_out
      flash_success_during_deactivate
      redirect_to url_after_destroy
    else
      flash_failure_during_deactivate
      redirect_to url_after_create
    end
  end

  private

  def url_after_destroy
    sign_in_path
  end

  def flash_success_during_deactivate
    flash[:notice] = translate('users.deactivate_success')
  end

  def flash_failure_during_deactivate
    flash[:notice] = translate('users.deactivate_failure')
  end

  def allowed_user_params
    params[:user].permit(:first_name, :last_name, :email, :password, :grade, :city, :state, :stripe_token, :coupon)
  end

  def user_from_params
    Clearance.configuration.user_model.new(allowed_user_params)
  end
end
