class Section < ActiveRecord::Base
  belongs_to :practice_test
  belongs_to :topic

  validates :topic, :practice_test, presence: true
  validates :name, presence: true, uniqueness: { scope: :practice_test_id }
end
