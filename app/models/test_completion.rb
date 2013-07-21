class TestCompletion < ActiveRecord::Base
  has_many :section_completions
  has_many :user_responses, through: :section_completions
  has_many :sections, through: :section_completions
  belongs_to :user
  belongs_to :practice_test

  def completed?
    percentage_complete == 100
  end

  def retake_available?
    completed?
  end

  def math_score
    return nil unless completed?
    ConversionTable.converted_score("M", raw_math_score)
  end

  def critical_reading_score
    return nil unless completed?
    ConversionTable.converted_score("CR", raw_critical_reading_score)
  end

  def writing_score
    return nil unless completed?
    ConversionTable.converted_score("W", raw_writing_score)
  end

  def total
    return nil unless completed?
    math_score + critical_reading_score + writing_score
  end

  def update!
    update_percentage_complete
    update_raw_scores if completed?
  end

  private
    def update_percentage_complete
      self.percentage_complete = (total_responses.to_f/total_questions) * 100
      self.save
    end

    def update_raw_scores
      RawScoreCalculator.new(self).update_scores!
    end

    def total_questions
      practice_test.questions.count
    end

    def total_responses
      user_responses.count
    end

end
