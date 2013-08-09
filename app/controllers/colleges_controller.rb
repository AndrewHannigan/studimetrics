class CollegesController < ApplicationController
  def index
    name = params[:filter] || ''
    @colleges = College.where("name ilike ?", "%#{name}%").order('name').to_a
    render json: @colleges
  end
end
