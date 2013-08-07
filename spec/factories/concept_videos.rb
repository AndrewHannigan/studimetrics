# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :concept_video do
    caption "Awesome"
    video_link "123"
    concept
  end
end
