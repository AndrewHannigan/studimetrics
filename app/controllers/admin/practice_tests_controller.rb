class Admin::PracticeTestsController < AdminController
  respond_to :html
  inherit_resources

  private

  def permitted_params
    params.permit(:practice_test => [:book_id, :name])
  end

end
