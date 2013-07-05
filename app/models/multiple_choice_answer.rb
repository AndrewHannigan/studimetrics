class MultipleChoiceAnswer < ActiveRecord::Base
  include SingleValueAnswer

  INPUT_CHOICES = ['A', 'B', 'C', 'D', 'E', Question::SKIP_VALUE]

  def to_partial_path
    "admin/answers/multiple_choice_answer"
  end
end
