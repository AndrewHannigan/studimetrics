# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_response do
    question {FactoryGirl.create(:question, :with_answers)}
    value "A"
    correct true
    time 100
    after(:create) do |user_response|
      user = create :user
      user_response.section_completion = FactoryGirl.create :section_completion, section: user_response.question.section, user: user
    end
  end
end
