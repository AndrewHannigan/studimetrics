class InvoicePaymentSucceededProcessor
  attr_accessor :user

  def initialize(params)
    customer_id = params[:data][:object][:customer]
    self.user = User.where(customer_id: customer_id).first

    if user
      clear_upcoming_invoice_cache
    end
  end

  private

  def clear_upcoming_invoice_cache
    Rails.cache.delete "user-#{user.id}-upcoming-invoice"
  end
end
