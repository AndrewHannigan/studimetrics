# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :section_completion do
    section
    status "In-Progress"
  end
end
