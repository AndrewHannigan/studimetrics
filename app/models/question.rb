class Question < ActiveRecord::Base
  QUESTION_TYPES = ["Range", "Single Value", "Free Response"]
  belongs_to :section
  has_many :range_answers, dependent: :destroy
  accepts_nested_attributes_for :range_answers, allow_destroy: true
  has_many :single_value_answers, dependent: :destroy
  accepts_nested_attributes_for :single_value_answers, allow_destroy: true
  has_many :free_response_answers, dependent: :destroy
  accepts_nested_attributes_for :free_response_answers, allow_destroy: true


  validates :name, presence: true, uniqueness: { scope: :section_id }
  validates :question_type, presence: true, inclusion: { in: QUESTION_TYPES, message: "Valid question types are: #{QUESTION_TYPES.to_sentence}"}

  delegate :name, to: :section, prefix: true

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

  private

  def answer_class_name
    "#{question_type.gsub(" ", "")}Answer"
  end

end
