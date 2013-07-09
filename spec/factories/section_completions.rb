# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :section_completion do
    user
    section
    status "Not Started"

    trait :in_progress do
      status "In-Progress"
    end
  end
end
