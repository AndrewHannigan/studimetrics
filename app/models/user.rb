class User < ActiveRecord::Base
  include Clearance::User
  include ProfileImage

  has_many :focus_ranks
  belongs_to :college
  has_many :section_completions, -> { order 'updated_at asc' }
  has_many :user_responses, through: :section_completions
  has_many :test_completions, -> { order 'created_at asc' }
  has_many :composite_scores

  delegate :name, to: :college, prefix: true

  validates :first_name, :last_name, :state, :high_school, presence: true
  validates :email, email: true, presence: true
  validates :password, presence: true, on: :create
  validates :sat_date, inclusion: { in: SatDate.upcoming_dates }, allow_nil: true
#  validates :stripe_token, presence: { message: 'Invalid credit card.' }, on: :create, unless: 'from_admin_tool.present?'
  validates :customer_id, presence: true, on: :update

  attr_accessor :stripe_token, :coupon, :from_admin_tool, :agree

  before_save :create_or_update_stripe_customer

  GRADES = %w(9th 10th 11th 12th)

  def location
    "#{self.city}, #{self.state}"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def current_test
    test = PracticeTest.joins(test_completions: :section_completions)
      .where(section_completions: {user_id: self.id})
      .order("section_completions.updated_at desc").first
    test || PracticeTest.first
  end

  def has_responses?
    user_responses.count > 0
  end

  def college
    super || NullCollege.new
  end

  def projected_total_score
    CompositeScore.projected_total_score_for_user(self)
  end

  def total_seconds_studied
    section_completion = self.section_completions.last
    Rails.cache.fetch("user_#{self.id}_#{section_completion.try(:cache_key)}_total_seconds_studied") do
      section_completions.sum(:section_time).to_f
    end
  end

  def has_watched_concept_video?(concept_video)
    ConceptVideoTracker.user_has_watched_concept_video?(self, concept_video)
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve customer_id
  end

  def upcoming_stripe_invoice
    if invoice_json.nil?
      Rails.cache.delete "user-#{id}-upcoming-invoice"
      nil
    else
      OpenStruct.new JSON.parse(invoice_json)
    end
  end

  def deactivate!
    SubscriptionCanceler.cancel self
    update_attributes(active: false)
  end

  def has_active_credit_card?
    last_4_digits.present?
  end

  def score_report_recipients
    ScoreReportEmail.new(self).recipients
  end

  def valid_stripe_customer?
    customer_id.present? && stripe_customer.present?
  end

  private

  def invoice_json
    Rails.cache.fetch "user-#{id}-upcoming-invoice" do
      stripe_invoice = Stripe::Invoice.upcoming customer: customer_id rescue nil

      if stripe_invoice
        stripe_invoice.to_json
      end
    end
  end

  def create_or_update_stripe_customer
    return if from_admin_tool

    if stripe_customer = StripeCustomerManager.create_or_update_stripe_customer(self)
      self.customer_id = stripe_customer.id
      self.last_4_digits = last_4_from_stripe_customer stripe_customer
      self.stripe_token = nil
      self.active = last_4_digits.present?
    end
    stripe_customer
  end

  def last_4_from_stripe_customer(stripe_customer)
    card = stripe_customer.cards.data.first
    if card.present?
      card['last4']
    else
      nil
    end
  end
end
