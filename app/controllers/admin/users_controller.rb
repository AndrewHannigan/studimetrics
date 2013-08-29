class Admin::UsersController < AdminController
  respond_to :html
  inherit_resources

  def index
    @users = User.order('created_at desc')
    index!
  end

  def create
    @user = User.new permitted_params[:user]
    @user.from_admin_tool = true
    create!
  end

  private

  def permitted_params
    params.permit(user: [:first_name, :last_name, :email, :password, :grade, :city, :state, :admin])
  end

end
