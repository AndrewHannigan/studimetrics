class ConceptProgress
  extend ActiveModel::Naming

  attr_accessor :user, :concept, :total_questions_for_concept, :responses_for_concept, :total_responses_for_concept

  def initialize(options ={})
    @user = options[:user]
    @concept = options[:concept]
  end

  def self.generate_for_user(user)
    Concept.all.collect do |concept|
      ConceptProgress.new(user: user, concept: concept)
    end
  end

  def percentage_complete
    (total_responses_for_concept.to_f/total_questions_for_concept).round(2) * 100
  end

  def average_time_for_responses
    responses_for_concept.average(:time) || 0
  end

  def frequency
    total_questions_for_concept
  end

  def accuracy
    (total_correct_responses_for_concept.to_f/total_questions_for_concept).round(2) * 100
  end

  def to_partial_path
    "/concept_progresses/concept_progress"
  end

  private
    def total_questions_for_concept
      @total_questions_for_concept ||= Question.joins(question_concepts: :concept).where(concepts: {id: concept.id}).count
    end

    def total_correct_responses_for_concept
      responses_for_concept.where(user_responses: {correct: true}).count
    end

    def total_responses_for_concept
      @total_response_for_concept ||= responses_for_concept.count
    end

    def responses_for_concept
      @responses_for_concept ||= UserResponse.joins(:section_completion, {question: {question_concepts: :concept}})
        .where(section_completions: {user_id: user.id, scoreable: true})
        .where(concepts: {id: concept.id})
    end
end
