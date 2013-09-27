class StripeEventController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def process_event
    begin
      processor_class = "#{params[:type].gsub('.', '_')}_processor".classify
      processor_class.constantize.new params
    rescue NameError
      Rails.logger.info "webhook called for #{params[:type]} but we dont care about it"
    end

    render nothing: true
  end

end
