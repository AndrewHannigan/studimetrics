# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :college do
    name "Indiana University"
    low_percentile_math 510
    high_percentile_math 620
    low_percentile_critical_reading 540
    high_percentile_critical_reading 660
    low_percentile_writing 510
    high_percentile_writing 610
    state 'Indiana'
  end
end
