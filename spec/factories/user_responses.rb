# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_response do
    question {FactoryGirl.create(:question, :with_answers)}
    section_completion {|resp| FactoryGirl.create :section_completion, section: resp.question.section}
    value "A"
    correct true
    time 100
  end
end
