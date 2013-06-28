# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :college do
    name "Indiana University"
    critical_reading 650
    math 700
    writing 700
  end
end
