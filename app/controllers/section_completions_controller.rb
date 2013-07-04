class SectionCompletionsController < ApplicationController
  before_filter :authorize

  def new
    section = Section.where(id: params[:section_id]).includes(:practice_test).first
    unless section.present?
      flash[:notice] = 'Invalid Section'
      return redirect_to :back
    end

    @section_completion = SectionCompletion.in_progress.where(user_id: current_user.id).where(section_id: section.id).first_or_create
    question_ids = @section_completion.question_ids
    section.questions.each do |question|
      unless question_ids.include? question.id
        @section_completion.user_responses.build question: question
      end
    end
  end

  def update
    @section_completion = SectionCompletion.find params[:id]

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
    params.require(:section_completion).permit(:section_id)
  end
end
