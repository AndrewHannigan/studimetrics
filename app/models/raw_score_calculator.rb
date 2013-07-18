class RawScoreCalculator
  attr_accessor :test_completion, :math, :critical_reading, :writing

  def initialize(test_completion)
    self.test_completion = test_completion
  end

  def calculate_scores
    calculate_math
    calculate_critical_reading
    calculate_writing
  end

  private
    def calculate_math
      test_completion.practice_test
    end

    def calculate_critical_reading

    end

    def calculate_writing

    end
end
