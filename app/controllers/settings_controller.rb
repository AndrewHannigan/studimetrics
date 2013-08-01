class SettingsController < ApplicationController
  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes setting_params
      redirect_to profile_url, notice: t('settings.saved_message')
    else
      flash[:error] = t('settings.save_failed_message')
      render :show
    end
  end

  private

  def setting_params
    params.require(:user).permit(:first_name, :last_name, :email, :profile_image, :college_id)
  end
end
