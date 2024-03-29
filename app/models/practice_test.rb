class PracticeTest < ActiveRecord::Base
  belongs_to :book
  has_many :sections, -> {order 'sections.number asc'}
  has_many :questions, through: :sections
  has_many :test_completions

  validates :book, presence: true
  validates :number, presence: true, uniqueness: { scope: :book_id }
  delegate :name, to: :book, prefix: true

  def book
    super || NullBook.new
  end

  def name
    "Test #{number}"
  end

  def sections_by_subject
    sections
      .joins(:subject)
      .select('sections.id')
      .select('subjects.name as subject_name')
      .select('subject_id')
      .select('number')
      .order('subject_id asc, number asc')
  end

  def question_count_by_subject(subj)
    questions_by_subject(subj).count
  end

  def first_section
    sections.order('number asc').first
  end

  def diagnostic?
    PracticeTest.minimum('number') == number
  end

  private

  def sections_for_subject(subj)
    sections.where(subject_id: subj.id)
  end

  def questions_by_subject(subj)
    section_ids = sections_for_subject(subj).pluck(:id)
    Question.where(section_id: section_ids)
  end

end
