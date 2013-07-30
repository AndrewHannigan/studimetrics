require 'spec_helper'

feature 'user visits practice page' do
  background do
    @practice_test = FactoryGirl.create :practice_test, number: 1
    @practice_test2 = FactoryGirl.create :practice_test, number: 2, book: @practice_test.book
  end

  scenario 'sees list of tests' do
    user = FactoryGirl.create :user
    visit practice_tests_path as: user.id

    expect(page).to have_content("#{@practice_test.name} Progress")
  end

end
