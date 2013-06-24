class Admin::QuestionsController < AdminController
  respond_to :html
  inherit_resources
  belongs_to :section

  def new
   @question = Question.new question_type: 'Range'
   @question.range_answers.build
   new!
  end

  def create
    create! do |success, failure|
      failure.html { Rails.logger.debug resource.errors.inspect  }
    end
  end

  private

  def permitted_params
    params.permit(question: [:id, :section_id, :name, :question_type, :section_id, range_answers_attributes: [:id, :min_value, :max_value, :_destroy]])
  end
end
