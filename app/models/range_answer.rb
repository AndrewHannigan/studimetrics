class RangeAnswer < ActiveRecord::Base
  belongs_to :question
  validates :min_value, :max_value, presence: true

  validate :min_must_be_less_than_max

  def valid_answer?(response)
    response_as_float = MathConversions.number_to_float response
    response_as_float > min_value && response_as_float < max_value
  end

  def to_partial_path
    "admin/answers/range_answer"
  end

  def answer
    "#{self.min_value}-#{self.max_value}"
  end

  private
    def min_must_be_less_than_max
      if min_value > max_value
        errors.add(:min_value, "can't be greater than the maximum value")
        errors.add(:max_value, "can't be less than the minimum value")
      end
    end
end
