FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    first_name "Robert"
    last_name "Beene"
    password 'password'
    city "New York"
    state "NY"
    grade "9th"
    admin false

    factory :admin do
      admin true
    end

    trait :with_college do
      college
    end
  end
end
