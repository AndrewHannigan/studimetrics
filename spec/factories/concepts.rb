# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :concept do
    sequence(:name) {|n| "geometry #{n}"}
    subject
  end
end
