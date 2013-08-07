class LastActivity
  attr_accessor :user, :practice_test, :section

  def initialize(options={})
    self.user = options[:user]
    self.practice_test = options[:practice_test]
  end

  def section
    @section ||= section_completion.try(:section)
  end

  private

    def section_completion
      @section_completion ||= user_response.try(:section_completion)
    end

    def user_response
      @user_response ||= UserResponse.joins(:section_completion).where(section_completions: {user_id: user.id}).order("updated_at desc").first
    end
  end
