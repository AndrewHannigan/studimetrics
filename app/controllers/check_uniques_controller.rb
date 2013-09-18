class CheckUniquesController < ApplicationController

  def email
    @instance = klass.new email: params[:email]
    @instance.valid?
  end

  private

  def klass
    params[:class].classify.constantize rescue User
  end

end
