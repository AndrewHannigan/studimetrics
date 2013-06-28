class Admin::CollegesController < AdminController
  respond_to :html
  inherit_resources

  private

  def permitted_params
    params.permit(college: [:name, :math, :writing, :critical_reading])
  end

end
