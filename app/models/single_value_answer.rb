class SingleValueAnswer < ActiveRecord::Base
  belongs_to :question

  def valid_answer?(response)
    self.value == response
  end
end
