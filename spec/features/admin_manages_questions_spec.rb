require 'spec_helper'


feature 'Admin manages questions and answers' do
  scenario 'adds a range question by default' do
    admin = FactoryGirl.create :admin
    section = FactoryGirl.create :section

    visit admin_practice_test_section_path(section.practice_test, section, as: admin.id)
    click_link 'Edit Questions'
    click_link 'New Question'

    fill_in 'Name', with: 'Question 1'
    select section.name, from: 'Section'
    select "Range", from: "Question type"

    fill_in 'Minimum Value', with: '1'
    fill_in 'Maximum Value', with: '23'

    click_button 'Create Question'

    expect(page).to have_content("Question was successfully created.")
  end

  scenario 'adds a single value question' do
    admin = FactoryGirl.create :admin
    section = FactoryGirl.create :section

    visit new_admin_section_question_path(section, question_type: 'Multiple Choice', as: admin.id)

    fill_in 'Name', with: 'Question 1'
    select section.name, from: 'Section'

    fill_in 'Value', with: '1'

    click_button 'Create Question'

    expect(page).to have_content("Question was successfully created.")
  end

  scenario 'adds a free range question' do
    admin = FactoryGirl.create :admin
    section = FactoryGirl.create :section

    visit new_admin_section_question_path(section, question_type: 'Free Response', as: admin.id)

    fill_in 'Name', with: 'Question 1'
    select section.name, from: 'Section'

    fill_in 'Value', with: '1234'

    click_button 'Create Question'

    expect(page).to have_content("Question was successfully created.")
  end

  scenario 'edits question', js: true do
    admin = FactoryGirl.create :admin
    question = FactoryGirl.create :question, question_type: 'Range'

    visit admin_section_questions_path(question.section, as: admin.id)
    click_link 'Edit'

    fill_in 'Name', with: 'Updated Question 1'
    select question.section.name, from: 'Section'

    click_link 'add answer'

    fill_in 'Minimum Value', with: '1'
    fill_in 'Maximum Value', with: '20'

    click_button 'Update Question'

    expect(page).to have_content("Question was successfully updated.")
  end

  scenario 'switches question type after the page loads', js: true do
    admin = FactoryGirl.create :admin
    section = FactoryGirl.create :section

    visit new_admin_section_question_path(section, question_type: 'Multiple Choice', as: admin.id)

    select 'Range', from: 'Question type'

    sleep 0.5
    fill_in 'Name', with: 'New range question'
    fill_in 'Minimum Value', with: '1'
    fill_in 'Maximum Value', with: '23'

    click_button 'Create Question'

    expect(page).to have_content("Question was successfully created.")
  end

end
