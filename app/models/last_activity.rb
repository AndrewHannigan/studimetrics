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
      @section_completion ||= SectionCompletion.where(user_id: user.id, status: "In-Progress").order("updated_at desc").first
    end
  end
