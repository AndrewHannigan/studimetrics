# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :range_answer do
    question
    min_value 1
    max_value 10
  end
end
