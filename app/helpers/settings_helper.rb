module SettingsHelper
  def next_charge_for_stripe_invoice(invoice)
    "#{total_amount_from_invoice invoice} on #{date_from_invoice invoice}" rescue 'N/A'
  end

  private

  def total_amount_from_invoice(invoice)
    number_to_currency (invoice.total/100).to_f
  end

  def date_from_invoice(invoice)
    Time.at(invoice.date).strftime '%m/%d/%Y'
  end
end
