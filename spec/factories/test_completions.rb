# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :test_completion do
    user
    practice_test
    raw_math_score 1
    raw_critical_reading_score 1
    raw_writing_score 1
    percentage_complete 0
  end
end
