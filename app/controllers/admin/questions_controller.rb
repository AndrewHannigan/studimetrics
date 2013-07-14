class Admin::QuestionsController < AdminController
  respond_to :html
  inherit_resources
  belongs_to :section, optional: true

  def new
    question_type = params[:question_type] || 'Range'
    @question = Question.new question_type: question_type, section: parent
    @question.send(:"#{@question.answer_association_name}").build
    new!
  end

  private

  def permitted_params
    params.permit(question: [:id, :position, :section_id, :name, :question_type, :section_id, multiple_choice_answers_attributes: [:id, :value, :_destroy], range_answers_attributes: [:id, :min_value, :max_value, :_destroy]])
  end
end
