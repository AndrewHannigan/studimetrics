class UsersController < Clearance::UsersController
  def create
    @user = user_from_params
    if @user.save
      sign_in @user
      SignupMailer.added(@user.id).deliver
      redirect_back_or url_after_create
    else
      render :template => 'users/new'
    end
  end

  def deactivate
    if current_user.deactivate!
      SignupMailer.removed(current_user.id).deliver
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
    params[:user].permit(:first_name, :last_name, :email, :password, :grade, :high_school, :city, :state, :stripe_token, :coupon)
  end

  def user_from_params
    Clearance.configuration.user_model.new(allowed_user_params)
  end
end
