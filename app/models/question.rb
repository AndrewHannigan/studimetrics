class Question < ActiveRecord::Base
  QUESTION_TYPES = ["Range", "Multiple Choice", "Free Response"]
  SKIP_VALUE = 'Skip'

  belongs_to :section
  has_many :question_concepts
  has_many :concepts, through: :question_concepts
  has_many :user_responses

  has_many :range_answers, dependent: :destroy
  accepts_nested_attributes_for :range_answers, allow_destroy: true
  has_many :multiple_choice_answers, dependent: :destroy
  accepts_nested_attributes_for :multiple_choice_answers, allow_destroy: true
  has_many :free_response_answers, dependent: :destroy
  accepts_nested_attributes_for :free_response_answers, allow_destroy: true

  validates :question_type, presence: true, inclusion: { in: QUESTION_TYPES, message: "Valid question types are: #{QUESTION_TYPES.to_sentence}"}

  delegate :name, to: :section, prefix: true
  delegate :name, to: :concept, prefix: true

  acts_as_list scope: :section

  def answers
    self.answer_class.where(question_id: self.id)
  end

  def answer_class
    answer_class_name.constantize
  end

  def answer_association_name
    answer_class_name.underscore.pluralize
  end

  def valid_answer?(response)
    answers.any?{|answer| answer.valid_answer?(response)}
  end

  def concept_names
    self.concepts.pluck(:name)
  end

  def name
    "Question #{position}"
  end

  def accepted_response
    answers.map(&:answer).join(', ')
  end

  private

  def answer_class_name
    "#{question_type.gsub(" ", "")}Answer"
  end

end
