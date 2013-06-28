class SectionCompletionsController < ApplicationController
  before_filter :authorize

  def new
    section = Section.where(id: params[:section_id]).includes(:practice_test).first
    unless section.present?
      flash[:notice] = 'Invalid Section'
      return redirect_to :back
    end

    @section_completion = SectionCompletion.new section: section
    section.questions.each do |question|
      @section_completion.user_responses.build question: question
    end
  end

  def create
    @section_completion = SectionCompletion.new section_completion_params
    @section_completion.user_responses.tap do |user_response|
      # TODO: uncomment after user is added to user_responses
      # user_response.user = current_user
    end

    if @section_completion.save
      redirect_to review_section_completion_path(@section_completion)
    else
      render :new
    end
  end

  def review

  end

  private

  def section_completion_params
    params.require(:section_completion).permit(user_responses_attributes: [:question_id, :value])
  end
end
