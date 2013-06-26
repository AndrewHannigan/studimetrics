class MultipleChoiceAnswer < ActiveRecord::Base
  belongs_to :question

  def valid_answer?(response)
    self.value == response
  end

  def to_partial_path
    "admin/answers/multiple_choice_answer"
  end

  def answer
    value
  end
end
