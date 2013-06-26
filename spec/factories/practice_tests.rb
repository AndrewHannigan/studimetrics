FactoryGirl.define do
  factory :practice_test do
    sequence(:number) {|n| n}
    book
  end
end
