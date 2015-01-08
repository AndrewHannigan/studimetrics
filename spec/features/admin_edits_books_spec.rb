require 'spec_helper'

feature 'admin manages books' do
  scenario 'creates a book' do
    admin = FactoryGirl.create :admin
    visit admin_books_path as: admin.id

    click_link 'New Book'

    fill_in 'Name', with: 'Updated Book Name'
    select 'College Board', from: 'Publisher'
    select '2014', from: 'book_publish_date_1i'
    select 'June', from: 'book_publish_date_2i'
    select '10', from: 'book_publish_date_3i'

    click_button 'Create Book'

    expect(page).to have_content("Book was successfully created.")
  end

  scenario 'edits a book' do
    FactoryGirl.create :book
    admin = FactoryGirl.create :admin

    visit admin_books_path as: admin.id
    click_link 'Edit'

    fill_in 'Name', with: 'Updated Book Name'
    select 'College Board', from: 'Publisher'
    select '2014', from: 'book_publish_date_1i'
    select 'June', from: 'book_publish_date_2i'
    select '10', from: 'book_publish_date_3i'

    click_button 'Update Book'

    expect(page).to have_content("Book was successfully updated.")
  end
end
