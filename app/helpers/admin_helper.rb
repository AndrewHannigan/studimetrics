module AdminHelper
  def breadcrumbs(hash)
    render 'breadcrumbs', breadcrumbs: hash
  end

  def action_links(hash)
    render 'action_links', action_links: hash
  end

  def admin_table(collection, options={})
    options[:columns] ||= collection.first.attributes.symbolize_keys.keys
    render 'table', options.merge(collection: collection)
  end

end
