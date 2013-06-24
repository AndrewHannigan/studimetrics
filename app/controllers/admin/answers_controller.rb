class Admin::AnswersController < AdminController
  respond_to :html
  inherit_resources
  belongs_to :question

  def create
    @answer = resource_class.new(permitted_params[:answer].merge(question_id: permitted_params[:question_id]))
    create!
  end

  private

  def resource_class
    parent.answer_class
  end

  def resource_class_as_sym
    resource_class.name.underscore.to_sym
  end

  def permitted_params
    params[:answer] = params[resource_class_as_sym]
    params.permit(:question_id, answer: [:value, :min_value, :max_value])
  end
end
