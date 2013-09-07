class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :math, :reading, :writing, :statistic

  before_filter do
    Honeybadger.context({
      user_id: current_user.id,
      user_email: current_user.email
    }) if current_user.is_a?(User)
  end

  def current_user
    super || NullUser.new
  end

  def math
    @math ||= Subject.where(name: "Math").first
  end

  def reading
    @reading ||= Subject.where(name: "Reading").first
  end

  def writing
    @writing ||= Subject.where(name: "Writing").first
  end

  def statistic
    return nil unless current_user
    @statistic ||= Statistic.new(current_user)
  end
end
