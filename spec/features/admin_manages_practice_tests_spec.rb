require 'spec_helper'

feature 'Admin manages practice tests' do
  scenario 'adds practice test' do
    admin = FactoryGirl.create :admin
    book = FactoryGirl.create :book

    visit admin_practice_tests_path as: admin.id

    click_link 'New Practice Test'

    fill_in 'Test name', with: 'Test 1'
    select book.name, from: 'Book'

    click_button 'Create Practice test'

    expect(page).to have_content("Practice test was successfully created.")
  end

  scenario 'edits practice test' do
    admin = FactoryGirl.create :admin
    test = FactoryGirl.create :practice_test

    visit admin_practice_test_path(test, as: admin.id)
    click_link 'Edit Practice Test'

    fill_in 'Test name', with: 'Test 2'

    click_button 'Update Practice test'

    expect(page).to have_content("Practice test was successfully updated.")
  end
end
