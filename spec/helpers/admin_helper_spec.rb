require 'spec_helper'

describe AdminHelper do
  describe '#breadcrumbs' do
    it 'renders the breadcrumb partial with the passed in hash' do
      hash = {'Admin' => 'wee.com' }
      helper.expects(:render).with('breadcrumbs', breadcrumbs: hash)
      helper.breadcrumbs(hash)
    end
  end

  describe '#action_links' do
    it 'renders the action links partial with the passed in hash' do
      hash = {'Admin' => 'wee.com' }
      helper.stubs(:render)
      helper.action_links(hash)

      expect(helper).to have_received(:render).with('action_links', action_links: hash)
    end
  end

  describe '#admin_table' do
    it 'renders a table with all columns by default' do
      collection = [User.new]
      helper.stubs(:render)

      helper.admin_table collection

      expect(helper).to have_received(:render).with('table', columns: User.new.attributes.symbolize_keys.keys, collection: collection)
    end

    it 'renders selected columns if they are passed in' do
      collection = [User.new]
      helper.stubs(:render)

      helper.admin_table collection, columns: [:id, :created_at]

      expect(helper).to have_received(:render).with('table', columns: [:id, :created_at], collection: collection)
    end
  end

  describe '#stripe_customer_link' do
    it 'returns a link to stripe' do
      user = build_stubbed :user, customer_id: 123
      link = helper.stripe_customer_link user

      expect(link).to eq link_to(user.customer_id, "https://manage.stripe.com/test/customers/#{user.customer_id}", target: :blank)
    end

    it 'returns None if the user doesnt have a customer id' do
      user = build_stubbed :user
      expect(helper.stripe_customer_link user).to eq 'None'

    end
  end
end
