# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    name "MyString"
    question_type "Single Value"
    section
  end
end