# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :focus_rank do
    user
    concept
    correct 0
    incorrect 0
    score "0"
    position 1
  end
end
