class SectionCompletionsController < ApplicationController
  before_filter :authorize
  before_filter :find_and_authorize_resource, only: [:update, :show]
  respond_to :html

  def new
    section = Section.where(id: params[:section_id]).includes(:practice_test).first
    unless section.present?
      flash[:notice] = 'Invalid Section'
      return redirect_to :back
    end

    @section_completion = find_or_create_section_completion(section)
    question_ids = @section_completion.question_ids
    section.questions.each do |question|
      unless question_ids.include? question.id
        @section_completion.user_responses.build question: question
      end
    end
  end

  def update
    @section_completion.complete!

    # TODO: if last one in test, make test completion

    respond_with @section_completion
  end

  def show
  end

  private

  def section_completion_params
    params.require(:section_completion).permit(:section_id)
  end

  def find_and_authorize_resource
    @section_completion = SectionCompletion.find params[:id]
    redirect_to profile_path unless @section_completion.user == current_user
  end

  def find_or_create_section_completion(section)
    section_completion = SectionCompletion.not_started_or_in_progress.where(user_id: current_user.id).where(section_id: section.id).last
    section_completion || SectionCompletion.create(user: current_user, section: section)
  end
end
