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
    return 1 if questions_count == 1

    lone_question_count = questions_count.odd? ? 1 : 0
    number_per_column = (questions_count/2).ceil + lone_question_count
    [1, number_per_column].max
  end

  def find_or_create_section_completion_for_user(user)
    section_completion = SectionCompletion.not_started_or_in_progress.where(user_id: user.id).where(section_id: id).last
    section_completion.touch if section_completion
    section_completion = section_completion || SectionCompletion.create(user: user, section: self)
    section_completion.set_scoreable!
    section_completion.associate_with_test_completion
    section_completion
  end
end
