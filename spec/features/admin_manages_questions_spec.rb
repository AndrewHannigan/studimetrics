require 'spec_helper'


feature 'Admin manages questions' do
  scenario 'adds question' do
    admin = FactoryGirl.create :admin
    question = FactoryGirl.create :question

    visit admin_practice_test_section_path(practice_test_id: question.section.practice_test, id: question.section_id, as: admin.id)
    click_link 'Edit Questions'
    click_link 'New Question'

    fill_in 'Name', with: 'Question 1'
    select question.section.name, from: 'Section'
    select "Single Value", from: "Question type"

    click_button 'Create Question'

    expect(page).to have_content("Question was successfully created.")
  end

  scenario 'edits question' do
    admin = FactoryGirl.create :admin
    question = FactoryGirl.create :question

    visit admin_practice_test_section_path(practice_test_id: question.section.practice_test, id: question.section_id, as: admin.id)
    click_link 'Edit Questions'
    click_link 'Edit'

    fill_in 'Name', with: 'Updated Question 1'
    select question.section.name, from: 'Section'
    select "Single Value", from: "Question type"

    click_button 'Update Question'

    expect(page).to have_content("Question was successfully updated.")
  end

end
