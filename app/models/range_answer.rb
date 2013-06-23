class RangeAnswer < ActiveRecord::Base
  belongs_to :question
  validates :question_id, :min_value, :max_value, presence: true

  validate :min_must_be_less_than_max

  def valid_answer?(response)
    response >= min_value && response <= max_value
  end

  private
    def min_must_be_less_than_max
      if min_value > max_value
        errors.add(:min_value, "can't be greater than the maximum value")
        errors.add(:max_value, "can't be less than the minimum value")
      end
    end
end
