# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :section_completion do
    user
    section
    status "Not Started"
    test_completion { create :test_completion, user: user, practice_test: section.practice_test}
    scoreable false

    trait :in_progress do
      status "In-Progress"
    end

  end
end
