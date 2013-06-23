class Admin::QuestionsController < AdminController
  respond_to :html
  inherit_resources
  belongs_to :section

  private

  def permitted_params
    params.permit(question: [:section_id, :name, :question_type])
  end
end
