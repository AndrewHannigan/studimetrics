# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :composite_score do
    user
    subject
    concepts {{}}
    composite_score nil
  end
end
