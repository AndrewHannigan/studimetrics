class Section < ActiveRecord::Base
  belongs_to :practice_test
  belongs_to :subject
  has_many :questions, -> { order 'position asc' }

  validates :subject, :practice_test, presence: true
  validates :number, presence: true, uniqueness: { scope: :practice_test_id }

  delegate :name, to: :subject, prefix: true
  delegate :name, to: :practice_test, prefix: true

  def name
    "Section #{number}"
  end
end
