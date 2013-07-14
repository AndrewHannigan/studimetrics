# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    question_type "Multiple Choice"
    section
    position nil

    trait :with_answers do
      after(:create) do |question|
        FactoryGirl.create(question.answer_association_name.singularize.to_sym, value: "A", question_id: question.id)
      end
    end

    factory :free_response_question do
      ignore do
        value '2.0'
      end
      question_type "Free Response"
      after(:create) do |question, evaluator|
        FactoryGirl.create(:free_response_answer, value: evaluator.value, question_id: question.id)
      end
    end

    factory :range_question do
      ignore do
        min_value '2.0'
        max_value '3.0'
      end
      question_type "Range"
      after(:create) do |question, evaluator|
        FactoryGirl.create(:range_answer, min_value: evaluator.min_value, max_value: evaluator.max_value, question_id: question.id)
      end
    end
  end
end
