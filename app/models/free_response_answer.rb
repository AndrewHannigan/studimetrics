class FreeResponseAnswer < ActiveRecord::Base
  include SingleValueAnswer

  validates :value, :length => { :maximum => 4,
            :too_long => "%{count} characters is the maximum allowed" }

  def to_partial_path
    "admin/answers/free_response_answer"
  end

  def valid_answer?(response)
    value.to_f == MathConversions.number_to_float(response)
  end
end
