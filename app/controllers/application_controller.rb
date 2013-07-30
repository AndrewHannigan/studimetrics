class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :math, :reading, :writing

  def current_user
    super || NullUser.new
  end

  def math
    @math ||= Subject.where(name: "Math").first
  end

  def reading
    @reading ||= Subject.where(name: "Critical Reading").first
  end

  def writing
    @writing ||= Subject.where(name: "Writing").first
  end
end
