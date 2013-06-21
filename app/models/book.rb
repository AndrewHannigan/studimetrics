class Book < ActiveRecord::Base

  PUBLISHERS = ['College Board']

  validates :name, :publish_date, presence: true
  validates :publisher, inclusion: { in: PUBLISHERS }, presence: true

end
