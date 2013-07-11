class Book < ActiveRecord::Base

  PUBLISHERS = ['College Board']

  has_many :practice_tests

  validates :name, :publish_date, presence: true
  validates :publisher, inclusion: { in: PUBLISHERS }, presence: true

end
