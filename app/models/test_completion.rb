class TestCompletion < ActiveRecord::Base
  has_many :section_completions
  has_many :user_responses, through: :section_completions
  has_many :sections, through: :section_completions
  belongs_to :user
  belongs_to :practice_test

  # def initialize(options={})
  #   @user = options[:user]
  #   @practice_test = options[:practice_test]
  #   @test_progress = TestProgress.new(user: user, practice_test: practice_test)
  # end

  # def section_completions
  #   @section_completions ||= SectionCompletion.where(user: user, section_id: practice_test.section_ids, scoreable: true).to_a
  # end

  def completed?
    percentage_complete == 100
  end

  def retake_available?
    completed?
  end

  def math_score
    ConversionTable.converted_score("M", raw_math_score)
  end

  def critical_reading_score
    ConversionTable.converted_score("CR", raw_critical_reading_score)
  end

  def writing_score
    ConversionTable.converted_score("W", raw_writing_score)
  end

  def total
    math_score + critical_reading_score + writing_score
  end

  def update_raw_scores
    Subject.all.each {|subj| update_score(subj)}
  end

  def update!
    update_percentage_complete
    update_raw_scores if completed?
  end

  private
    def update_percentage_complete
      self.percentage_complete = (total_responses.to_f/total_questions) * 100
    end

    def total_questions
      practice_test.questions.count
    end

    def total_responses
      user_responses.count
    end

    def update_score(subj)

    end

    def total_correct_for_subject(subj)

    end

    def total_incorrect_excluding_free_response_for_subject(subj)
    end

end
