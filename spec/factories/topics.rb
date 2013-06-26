FactoryGirl.define do
  factory :topic do
    sequence(:name) {|n| "geometry #{n}"}
  end
end
