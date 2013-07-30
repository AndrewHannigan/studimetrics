class Section < ActiveRecord::Base
  belongs_to :practice_test
  belongs_to :subject
  has_many :questions, -> { order 'position asc' }
  has_many :section_completions

  validates :subject, :practice_test, presence: true
  validates :number, presence: true, uniqueness: { scope: :practice_test_id }

  delegate :name, to: :subject, prefix: true
  delegate :name, to: :practice_test, prefix: true

  def name
    "Section #{number}"
  end

  def questions_count
    questions.count
  end

  def question_count_per_column
    [1, (questions.count/2).ceil].max
  end
end
