# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :test_completion do
    user
    practice_test
    percentage_complete 0
  end
end
