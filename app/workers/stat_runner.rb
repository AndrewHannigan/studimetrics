class StatRunner
  include Sidekiq::Worker

  attr_accessor :section_completion, :user, :test_completion, :section_completion_id

  def perform(section_completion_id)
    @section_completion_id = section_completion_id
    create_skipped_responses_for_section_completion
    test_completion.try(:update!)
    composite_score.try(:update!, section_completion.concepts)
    FocusRank.update_scores_for_concepts_and_user(section_completion.concepts, section_completion.user)
  end

  private

    def create_skipped_responses_for_section_completion
      return unless section_completion
      return if section_completion.all_questions_answered?
      section_completion.section.questions.each do |question|
        find_or_create_skipped_response(question)
      end
    end

    def find_or_create_skipped_response(question)
      user_response = UserResponse.where(question: question, section_completion: section_completion).first
      unless user_response
        UserResponse.create!(section_completion: section_completion, value: Question::SKIP_VALUE, question: question)
      end
    end

    def section_completion
      @section_completion = SectionCompletion.find(section_completion_id)
    end

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
