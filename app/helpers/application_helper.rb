module ApplicationHelper
  def breadcrumbs(hash)
    render 'breadcrumbs', breadcrumbs: hash
  end
end
