# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :free_response_answer do
    question
    value "A"
  end
end
