class Book < ActiveRecord::Base

  PUBLISHERS = ['College Board']
  AMAZON_LINK = 'http://www.amazon.com/gp/product/0874478529/ref=as_li_tf_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0874478529&linkCode=as2&tag=studimetric0c-20'

  has_many :practice_tests

  validates :name, :publish_date, presence: true
  validates :publisher, inclusion: { in: PUBLISHERS }, presence: true

end
