class TestCompletion < ActiveRecord::Base
  has_many :section_completions
  has_many :user_responses, through: :section_completions
  has_many :sections, through: :section_completions
  belongs_to :user
  belongs_to :practice_test

  delegate :name, to: :practice_test, prefix: true

  scope :completed, -> { where(percentage_complete: 100) }

  def completed?
    percentage_complete == 100
  end

  def retake_available?
    completed?
  end

  def math_score
    return nil unless completed?
    ConversionTable.converted_score("M", raw_math_score.to_i)
  end

  def critical_reading_score
    return nil unless completed?
    ConversionTable.converted_score("CR", raw_critical_reading_score.to_i)
  end

  def writing_score
    return nil unless completed?
    ConversionTable.converted_score("W", raw_writing_score.to_i)
  end

  def total
    return nil unless completed?
    math_score + critical_reading_score + writing_score
  end

  def update!
    update_percentage_complete
    collect_and_update_raw_scores if completed?
    self.save
  end

  private
    def update_percentage_complete
      return unless test_has_questions?
      self.percentage_complete = (total_responses.to_f/total_questions) * 100
      self.save
    end

    def test_has_questions?
      total_questions > 0
    end

    def collect_and_update_raw_scores
      raw_scores.each do |subj, value|
        self.send("#{raw_score_field_for_subject(subj)}=", value)
      end
      self.save
    end

    def raw_scores
      RawScoreCalculator.new(self).collect_scores
    end

    def total_questions
      practice_test.questions.count
    end

    def total_responses
      user_responses.count
    end

    def raw_score_field_for_subject(subject_name)
      "raw_#{subject_name.split(" ").join("").underscore}_score"
    end

end
