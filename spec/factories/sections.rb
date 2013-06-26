FactoryGirl.define do
  factory :section do
    sequence(:number) {|n| n}
    practice_test
    subject
  end
end
