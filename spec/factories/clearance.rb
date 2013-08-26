FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :customer_id do |n|
    "stripe-id-#{n}"
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
    stripe_token { StripeMock.generate_card_token(last4: "9191", exp_month: 12, exp_year: Time.now.year+2.years) }

    factory :admin do
      admin true
    end

    trait :with_college do
      college
    end
  end
end
