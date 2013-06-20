class AdminController < ApplicationController
  layout 'admin'

  before_filter :authorize_admin

  private

  def authorize_admin
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
