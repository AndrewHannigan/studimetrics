FactoryGirl.define do
  factory :topic do
    sequence(:name) {|n| "Math #{n}"}
    subject "something"
  end
end
