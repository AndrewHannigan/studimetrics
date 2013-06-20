FactoryGirl.define do
  factory :book do
    name "Cool Book"
    publisher { Book::PUBLISHERS.first }
    publish_date "2013-06-20"
  end
end
