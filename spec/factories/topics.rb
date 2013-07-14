FactoryGirl.define do
  factory :topic do
    sequence(:name) {|n| "geometry #{n}"}
    subject
  end
end
