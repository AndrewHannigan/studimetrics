class UserResponsesController < ApplicationController
  before_filter :authorize
  respond_to :json

  def create
    new_response = UserResponse.where(question_id: question.id).where(section_completion_id: section_completion.id).first_or_create
    new_response.value = user_response_params[:value]
    new_response.add_time user_response_params[:time]
    new_response.save
    respond_with(user_response, location: nil)
  end

  private

  def user_response_params
    params.require(:user_response).permit(:question_id, :value, :time)
  end

  def section_completion
    @section_completion ||= SectionCompletion.in_progress.where(user_id: current_user.id).where(section_id: question.section_id).first_or_create
  end

  def question
    Question.find user_response_params[:question_id]
  end
end
