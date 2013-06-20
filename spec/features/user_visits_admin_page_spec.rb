require 'spec_helper'

feature 'User visits admin page' do
  scenario 'as an admin' do
    user = FactoryGirl.create :admin
    visit admin_path as: user.id

    expect(current_path).to eq(admin_path)
  end

  scenario 'as a regular user' do
    user = FactoryGirl.create :user
    visit admin_path as: user.id

    expect(current_path).to eq(root_path)
  end
end
