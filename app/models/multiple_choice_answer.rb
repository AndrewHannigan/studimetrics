class MultipleChoiceAnswer < ActiveRecord::Base
  belongs_to :question
  validates :value, :length => { :maximum => 4,
            :too_long => "%{count} characters is the maximum allowed" }

  INPUT_CHOICES = %w(A B C D E Skip)

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
