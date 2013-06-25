class Section < ActiveRecord::Base
  belongs_to :practice_test
  belongs_to :topic
  has_many :questions, -> { order 'position asc' }

  validates :topic, :practice_test, presence: true
  validates :name, presence: true, uniqueness: { scope: :practice_test_id }

  delegate :name, to: :topic, prefix: true
end
