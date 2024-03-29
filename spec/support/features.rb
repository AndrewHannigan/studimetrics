Dir[Rails.root.join('spec/support/features/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include Features::ClearanceHelpers, type: :feature
  config.include Features::ActionMailerHelpers, type: :feature
  config.include Features::PracticeTestHelpers, type: :feature
  config.include Features::CreditCardHelpers, type: :feature
end
