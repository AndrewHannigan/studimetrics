Clearance.configure do |config|
  config.mailer_sender = 'reply@example.com'
  config.password_strategy = Clearance::PasswordStrategies::BCrypt
  config.redirect_url = '/profile'
end
