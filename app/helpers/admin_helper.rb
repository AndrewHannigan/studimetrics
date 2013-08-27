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

  def stripe_customer_link(user)
    if user.customer_id.present?
      path = Rails.env.production? ? '' : 'test/'
      link_to user.customer_id, "https://manage.stripe.com/#{path}customers/#{user.customer_id}", target: :blank
    else
      'None'
    end
  end

end
