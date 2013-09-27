require 'spec_helper'

describe InvoicePaymentSucceededProcessor do
  it 'clears the user upcoming invoice cache' do
    user = create :user
    Rails.cache.expects(:delete)

    InvoicePaymentSucceededProcessor.new data: { object: { customer: user.customer_id }}

    expect(Rails.cache).to have_received(:delete).with("user-#{user.id}-upcoming-invoice")
  end
end
