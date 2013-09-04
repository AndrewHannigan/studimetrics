class ScoreReportEmail
  attr_accessor :user, :email

  include ActiveModel::Validations
  validate :email, presence: true, email: true

  REDIS_KEY = "user:%ID%:score_report_emails"

  def initialize(user)
    @user = user
  end

  def recipients
    REDIS.smembers redis_key
  end

  def add_recipient(email)
    @email = email
    if valid?
      REDIS.sadd redis_key, email
    end
  end

  def remove_recipient(email)
    @email = email
    REDIS.srem redis_key, email
  end

  private

  def redis_key
    REDIS_KEY.gsub "%ID%", user.id.to_s
  end

end
