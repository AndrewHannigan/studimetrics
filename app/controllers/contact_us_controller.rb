class ContactUsController < ApplicationController
  def create
    ContactMailer.contact_us(contact_us_params).deliver
    redirect_to root_path, notice: 'Your message has been sent!'
  end
end

private

def contact_us_params
  params.require(:contact_us).permit(:name, :email, :question)
end
