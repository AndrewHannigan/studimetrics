class ConceptProgress
  attr_accessor :user, :topic, :total_questions_for_topic, :responses_for_topic, :total_responses_for_topic

  def initialize(options ={})
    @user = options[:user]
    @topic = options[:topic]
  end

  def percentage_complete
    (total_responses_for_topic.to_f/total_questions_for_topic).round(2) * 100
  end

  def average_time_for_responses
    responses_for_topic.average(:time) || 0
  end

  def frequency
    total_questions_for_topic
  end

  def accuracy
    (total_correct_responses_for_topic.to_f/total_questions_for_topic).round(2) * 100
  end

  private
    def total_questions_for_topic
      @total_questions_for_topic ||= Question.where(topic: topic).count
    end

    def total_correct_responses_for_topic
      responses_for_topic.where(user_responses: {correct: true}).count
    end

    def total_responses_for_topic
      @total_response_for_topic ||= responses_for_topic.count
    end

    def responses_for_topic
      @responses_for_topic ||= UserResponse.joins(:section_completion, :question)
        .where(section_completions: {user_id: user.id, scoreable: true})
        .where(questions: {topic_id: topic.id})
    end
end
