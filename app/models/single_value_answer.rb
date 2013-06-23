class SingleValueAnswer < ActiveRecord::Base
  belongs_to :question

  def valid_answer?(response)
    self.value == response
  end

  def to_partial_path
    "admin/answers/single_value_answer"
  end

  def answer
    value
  end
end
