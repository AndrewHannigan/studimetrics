require 'spec_helper'

describe StripeEventController do
  describe '#process_event' do
    it 'instantiates a new processor class if we care about the hook' do
      InvoicePaymentSucceededProcessor.expects(:new)

      post 'process_event', invoice_payment_succeeded_params

      expect(response.code).to eq '200'
      expect(InvoicePaymentSucceededProcessor).to have_received(:new)
    end

    it 'ignores it otherwise' do
      post 'process_event', type: 'fake!'
      expect(response.code).to eq '200'
    end
  end
end

def invoice_payment_succeeded_params
  {"created"=>1326853478, "livemode"=>false, "id"=>"evt_00000000000000", "type"=>"invoice.payment_succeeded", "object"=>"event", "data"=>{"object"=>{"date"=>1380244106, "id"=>"in_00000000000000", "period_start"=>1380244106, "period_end"=>1380244106, "lines"=>{"data"=>[{"id"=>"su_2eKrrUdgWVWjrF", "object"=>"line_item", "type"=>"subscription", "livemode"=>true, "amount"=>0, "currency"=>"usd", "proration"=>false, "period"=>{"start"=>1380244106, "end"=>1380503306}, "quantity"=>1, "plan"=>{"interval"=>"month", "name"=>"Studimetrics Subscription", "amount"=>900, "currency"=>"usd", "id"=>"studimetrics", "object"=>"plan", "livemode"=>false, "interval_count"=>1, "trial_period_days"=>3}, "description"=>nil}], "count"=>1, "object"=>"list", "url"=>"/v1/invoices/in_2e80zH9PrUVlaO/lines"}, "subtotal"=>0, "total"=>0, "customer"=>"cus_00000000000000", "object"=>"invoice", "attempted"=>true, "closed"=>true, "paid"=>true, "livemode"=>false, "attempt_count"=>0, "amount_due"=>0, "currency"=>"usd", "starting_balance"=>0, "ending_balance"=>nil, "next_payment_attempt"=>nil, "charge"=>"_00000000000000", "discount"=>nil, "application_fee"=>nil}}, "stripe_event"=>{"created"=>1326853478, "livemode"=>false, "id"=>"evt_00000000000000", "type"=>"invoice.payment_succeeded", "object"=>"event", "data"=>{"object"=>{"date"=>1380244106, "id"=>"in_00000000000000", "period_start"=>1380244106, "period_end"=>1380244106, "lines"=>{"data"=>[{"id"=>"su_2eKrrUdgWVWjrF", "object"=>"line_item", "type"=>"subscription", "livemode"=>true, "amount"=>0, "currency"=>"usd", "proration"=>false, "period"=>{"start"=>1380244106, "end"=>1380503306}, "quantity"=>1, "plan"=>{"interval"=>"month", "name"=>"Studimetrics Subscription", "amount"=>900, "currency"=>"usd", "id"=>"studimetrics", "object"=>"plan", "livemode"=>false, "interval_count"=>1, "trial_period_days"=>3}, "description"=>nil}], "count"=>1, "object"=>"list", "url"=>"/v1/invoices/in_2e80zH9PrUVlaO/lines"}, "subtotal"=>0, "total"=>0, "customer"=>"cus_00000000000000", "object"=>"invoice", "attempted"=>true, "closed"=>true, "paid"=>true, "livemode"=>false, "attempt_count"=>0, "amount_due"=>0, "currency"=>"usd", "starting_balance"=>0, "ending_balance"=>nil, "next_payment_attempt"=>nil, "charge"=>"_00000000000000", "discount"=>nil, "application_fee"=>nil}}}}
end
