class FreeResponseAnswer < ActiveRecord::Base
  belongs_to :question
  validates :value, :length => { :maximum => 4,
        :too_long => "%{count} characters is the maximum allowed" }

  def valid_answer?(response)
    response == value
  end
end
