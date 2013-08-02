require 'spec_helper'

describe User do
  it_behaves_like "a profile image"

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
end
