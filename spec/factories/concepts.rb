# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :concept do
    sequence(:name) {|n| "geometry #{n}"}
    subject
    description {|s| "#{s.name} is the study of interesting things you should know"}
  end
end
