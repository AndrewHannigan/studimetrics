class User < ActiveRecord::Base
  include Clearance::User
  include ProfileImage

  has_many :focus_ranks
  belongs_to :college
  has_many :section_completions, -> { order 'created_at asc' }
  has_many :user_responses, through: :section_completions
  has_many :test_completions, -> { order 'created_at asc' }

  delegate :name, to: :college, prefix: true

  validates :first_name, :last_name, presence: true
  validates :sat_date, inclusion: { in: SatDate.upcoming_dates }, allow_nil: true
  validates :stripe_token, presence: { message: 'Invalid credit card.' }, on: :create, unless: 'from_admin_tool.present?'
  validates :customer_id, presence: true, on: :update

  attr_accessor :stripe_token, :coupon, :from_admin_tool

  before_save :create_or_update_stripe_customer

  GRADES = %w(9th 10th 11th 12th)

  def location
    "#{self.city}, #{self.state}"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def current_test
    PracticeTest.first
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
   section_completions.sum(:section_time).to_f
  end

  def has_watched_concept_video?(concept_video)
    ConceptVideoTracker.user_has_watched_concept_video?(self, concept_video)
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve customer_id
  end

  def upcoming_stripe_invoice
    @stripe_invoice ||= Stripe::Invoice.upcoming customer: customer_id
  end

  def deactivate!
    update_attributes(active: false, last_4_digits: nil)
    SubscriptionCanceler.cancel self
  end

  private

  def create_or_update_stripe_customer
    return if from_admin_tool

    if stripe_customer = StripeCustomerManager.create_or_update_stripe_customer(self)
      self.customer_id = stripe_customer.id
      self.last_4_digits = last_4_from_stripe_customer stripe_customer
      self.stripe_token = nil
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
