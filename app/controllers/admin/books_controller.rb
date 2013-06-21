class Admin::BooksController < AdminController
  respond_to :html
  inherit_resources

  private

  def permitted_params
    params.permit(:book => [:name, :publisher, :publish_date])
  end

end
