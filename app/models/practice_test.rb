class PracticeTest < ActiveRecord::Base
  belongs_to :book
  has_many :sections
  has_many :questions, through: :sections

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

end
