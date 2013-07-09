class UserResponsesController < ApplicationController
  before_filter :authorize
  respond_to :json

  def create
    new_response = UserResponse.where(question_id: question.id).where(section_completion_id: section_completion.id).first_or_create
    new_response.value = user_response_params[:value]
    new_response.add_time user_response_params[:time]
    new_response.save
    mark_section_in_progress
    respond_with(user_response, location: nil)
  end

  private

  def user_response_params
    params.require(:user_response).permit(:question_id, :value, :time)
  end

  def section_completion
    @section_completion ||= SectionCompletion.not_started_or_in_progress.where(user_id: current_user.id).where(section_id: question.section_id).last
  end

  def mark_section_in_progress
    @section_completion.progress! unless @section_completion.started?
  end

  def user_response
    UserResponse.where(question_id: question.id).where(section_completion_id: section_completion.id).first_or_create
  end

  def question
    Question.find user_response_params[:question_id]
  end
end
