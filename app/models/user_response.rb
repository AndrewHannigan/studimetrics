class UserResponse < ActiveRecord::Base
  belongs_to :question
  belongs_to :section_completion, touch: true
  after_save :score_response

  def add_time(new_time)
    self.time = time + new_time.to_f
  end

  def time
    super || 0
  end

  def value_or_skip
    value.to_s.gsub Question::SKIP_VALUE, ''
  end

  def skipped?
    value == Question::SKIP_VALUE
  end

  def correct?
    question.valid_answer? value
  end

  private

  def score_response
    unless skipped? || value.nil?
      update_column 'correct', correct?
    end
  end
end
