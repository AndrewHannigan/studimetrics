require 'spec_helper'

describe User do
  it_behaves_like "a profile image"

  describe 'create_or_update_stripe_customer' do
    it 'does not save a user if there was is a stripe issue' do
      StripeCustomerManager.expects(:create_or_update_stripe_customer).returns(false)
      user = build :user, customer_id: nil, stripe_token: 'asdf', from_admin_tool: false
      user.save

      expect(user.id).to be_nil
    end

    it 'sets the last 4 and the customer id if successful' do
      card_token = StripeMock.generate_card_token(last4: "9191", exp_month: 99, exp_year: 3005)
      mocked_stripe_customer = Stripe::Customer.create card: card_token
      StripeCustomerManager.expects(:create_or_update_stripe_customer).returns(mocked_stripe_customer)

      user = build :user, customer_id: nil, stripe_token: 'asdf', from_admin_tool: false
      user.save

      expect(user.customer_id).to eq mocked_stripe_customer.id
      expect(user.last_4_digits).to eq '9191'
    end
  end

  describe "#location" do
    it 'returns comma-separated city and state' do
      user = User.new(city: "New York", state: "NY")

      expect(user.location).to eq "#{user.city}, #{user.state}"
    end
  end

  describe "#full_name" do
    it 'returns first name and last name combined' do
      user = User.new(first_name: "Robert", last_name: "Beene")

      expect(user.full_name).to eq "#{user.first_name} #{user.last_name}"
    end
  end

  describe "#current_test" do
    it 'returns the first test' do
      practice_test = create :practice_test
      user = User.new

      expect(user.current_test).to eq(practice_test)
    end
  end

  describe "has_responses?" do
    it 'returns true if the user has any user responses' do
      response = create :user_response
      user = response.section_completion.user
      expect(user.has_responses?).to be_true
    end

    it 'returns false otherwise' do
      user = User.new
      expect(user.has_responses?).to be_false
    end
  end

  describe '#projected_total_score' do
    it 'gets the score from composite score' do
      CompositeScore.expects(:projected_total_score_for_user).returns(250)

      user = User.new
      expect(user.projected_total_score).to eq 250
    end
  end

  describe '#total_seconds_studied' do
    it 'returns 0 if there are no seconds studied' do
      user = User.new
      expect(user.total_seconds_studied).to eq 0
    end

    it 'returns the total seconds studied by summing the section time' do
      user = create :user
      user.section_completions << create(:section_completion, section_time: 100)
      user.section_completions << create(:section_completion, section_time: 100)

      expect(user.total_seconds_studied).to eq 200

    end
  end

  describe '#has_watched_concept_video?' do
    it 'calls ConceptVideoTracker' do
      user = User.new
      concept_video = ConceptVideo.new
      ConceptVideoTracker.expects(:user_has_watched_concept_video?)

      user.has_watched_concept_video? concept_video

      expect(ConceptVideoTracker).to have_received(:user_has_watched_concept_video?)
    end
  end

  describe '#stripe_customer' do
    it 'calls Stripe::Customer.retrieve with the users customer id' do
      stripe_customer = Stripe::Customer.create email: 'asdf@wee.net'
      Stripe::Customer.expects(:retrieve)
      user = User.new customer_id: stripe_customer.id

      user.stripe_customer

      expect(Stripe::Customer).to have_received(:retrieve).with(stripe_customer.id)
    end
  end

  describe '#upcoming_stripe_invoice' do
    it 'calls Stripe::Invoice.upcoming with the customer id' do
      customer = Stripe::Customer.create
      Stripe::Invoice.expects(:upcoming)
      user = User.new customer_id: customer.id

      user.upcoming_stripe_invoice

      expect(Stripe::Invoice).to have_received(:upcoming).with(has_entry :customer, customer.id)
    end
  end

  describe '#deactivate!' do
    it 'sets active to false' do
      user = User.new active: true
      user.deactivate!
      expect(user).to_not be_active
    end

    it 'calls SubscriptionCanceler' do
      user = User.new
      SubscriptionCanceler.expects(:cancel)
      user.deactivate!

      expect(SubscriptionCanceler).to have_received(:cancel).with(user)
    end
  end

  describe '#score_report_emails' do
    it 'calls ScoreReportEmail' do
      user = User.new
      ScoreReportEmail.any_instance.expects(:recipients)
      user.score_report_recipients

      expect(ScoreReportEmail.any_instance).to have_received(:recipients)
    end
  end

  describe '#valid_stripe_customer?' do
    it 'returns true if they are valid' do
      customer = Stripe::Customer.create email: 'asdf@wee.net'
      user = User.new customer_id: customer.id

      expect(user).to be_valid_stripe_customer
    end

    it 'returns false otherwise' do
      user = User.new

      expect(user).to_not be_valid_stripe_customer
    end
  end

end
