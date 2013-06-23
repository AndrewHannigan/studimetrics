class Question < ActiveRecord::Base
  QUESTION_TYPES = ["Range", "Single Value"]
  belongs_to :section

  validates :name, presence: true, uniqueness: { scope: :section_id }
  validates :question_type, presence: true, inclusion: { in: QUESTION_TYPES, message: "Valid question types are: #{QUESTION_TYPES.to_sentence}"}

  def answers
    self.answer_class.where(question_id: self.id)
  end

  def answer_class
    (self.question_type.gsub(" ", "") + "Answer").constantize
  end

  def valid_answer?(response)
    answers.any?{|answer| answer.valid_answer?(response)}
  end
end
