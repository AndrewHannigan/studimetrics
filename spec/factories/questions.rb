# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    question_type "Multiple Choice"
    section
    position nil

    trait :with_answers do
      after(:create) do |question|
        FactoryGirl.create(:multiple_choice_answer, value: "A", question_id: question.id)
      end
    end
  end
end
