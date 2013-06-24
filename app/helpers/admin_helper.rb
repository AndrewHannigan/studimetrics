module AdminHelper
  def breadcrumbs(hash)
    render 'breadcrumbs', breadcrumbs: hash
  end

  def action_links(hash)
    render 'action_links', action_links: hash
  end

end
