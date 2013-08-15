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
    if @section_completion.scoreable?
      @section_completion.section_time = section_completion_params[:section_time].to_f
      @section_completion.reading_time = section_completion_params[:reading_time].to_f
      @section_completion.save
    end
    @section_completion.complete!
    respond_with @section_completion
  end

  def show
  end

  private

  def section_completion_params
    params.require(:section_completion).permit(:section_id, :section_time, :reading_time)
  end

  def find_and_authorize_resource
    @section_completion = SectionCompletion.find params[:id]
    redirect_to root_path unless @section_completion.user == current_user
  end

  def associate_with_test_completion(section_completion)
    return if section_completion.retake?
    test_completion = TestCompletion.where(user: current_user, practice_test_id: section_completion.section.practice_test_id).first_or_create
    section_completion.update_attributes!(test_completion: test_completion)
  end

  def find_or_create_section_completion(section)
    section_completion = SectionCompletion.not_started_or_in_progress.where(user_id: current_user.id).where(section_id: section.id).last
    section_completion.touch if section_completion
    section_completion = section_completion || SectionCompletion.create(user: current_user, section: section)
    section_completion.set_scoreable!
    associate_with_test_completion(section_completion)
    section_completion
  end

end
