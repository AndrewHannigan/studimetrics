class ConceptProgress
  attr_accessor :user, :topic

  def initialize(options ={})
    @user = options[:user]
    @topic = options[:topic]
  end

  def percentage_complete
    (total_responses_for_topic.to_f/total_questions_for_topic).round(2) * 100
  end

  private
    def total_questions_for_topic
      Question.where(topic: topic).count
    end

    def total_responses_for_topic
      UserResponse.joins(:section_completion, :question)
        .where(section_completions: {user_id: user.id, scoreable: true})
        .where(questions: {topic_id: topic.id}).count
    end
end
