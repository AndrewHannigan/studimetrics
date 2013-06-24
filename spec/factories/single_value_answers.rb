# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :single_value_answer do
    question
    value "A"
  end
end
