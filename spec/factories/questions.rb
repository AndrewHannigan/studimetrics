# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    question_type "Multiple Choice"
    section
    position nil
  end
end
