require 'spec_helper'

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
