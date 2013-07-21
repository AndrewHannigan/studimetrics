class StatRunner
  attr_accessor :section_completion, :user, :test_completion

  def initialize(section_completion)
    @section_completion = section_completion
  end

  def perform!
    test_completion.delay(:update!) if test_completion
    #composite_score.delay(:update!) if composite_score
  end

  private

    def user
      @user ||= section_completion.user
    end

    def subject
      @subject ||= Subject.joins(sections: :section_completions)
        .where(section_completions: {id: section_completion.id}).first
    end

    def test_completion
      @test_completion ||= section_completion.test_completion
    end


    # def composite_score
    #   @composite_score ||= CompositeScore.where(subject: subject).where(user: user).first_or_create section_completion.scoreable?
    # end

end
