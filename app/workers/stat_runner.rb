class StatRunner
  include Sidekiq::Worker

  attr_accessor :section_completion, :user, :test_completion

  def initialize(section_completion_id)
    @section_completion = SectionCompletion.find(section_completion_id)
  end

  def perform!
    test_completion.try(:update!)
    composite_score.try(:update!)
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


    def composite_score
      @composite_score ||= CompositeScore.where(subject: subject, user: user).first_or_create if section_completion.scoreable?
    end

end
