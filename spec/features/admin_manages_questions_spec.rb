require 'spec_helper'

feature 'Admin manages questions and answers' do
  scenario 'adds a range question by default' do
    admin = FactoryGirl.create :admin
    section = FactoryGirl.create :section
    concept = create :concept

    visit admin_practice_test_section_path(section.practice_test, section, as: admin.id)
    click_link 'Edit Questions'
    click_link 'New Question'

    fill_in 'Position', with: '1'
    select section.name, from: 'Section'
    select "Range", from: "Question type"
    select concept.name, from: "Concept"

    fill_in 'Minimum Value', with: '1'
    fill_in 'Maximum Value', with: '23'

    click_button 'Create Question'

    expect(page).to have_content("Question was successfully created.")
  end

  scenario 'adds a free response question' do
    admin = create :admin
    section = create :section
    concept = create :concept

    visit new_admin_section_question_path(section, question_type: 'Free Response', as: admin.id)

    fill_in 'Position', with: '2'
    select section.name, from: 'Section'
    select concept.name, from: "Concept"
    fill_in 'Value', with: '1'
    click_button 'Create Question'

    expect(page).to have_content("Question was successfully created.")
  end

  scenario 'adds a multiple choice question' do
    admin = create :admin
    section = create :section
    concept = create :concept

    visit new_admin_section_question_path(section, question_type: 'Multiple Choice', as: admin.id)

    fill_in 'Position', with: '3'
    select section.name, from: 'Section'
    select concept.name, from: "Concept"
    select 'A', from: 'Value'
    click_button 'Create Question'

    expect(page).to have_content("Question was successfully created.")
  end

  scenario 'edits question', js: true do
    admin = FactoryGirl.create :admin
    question = FactoryGirl.create :question, question_type: 'Range'
    concept = create :concept

    visit admin_section_questions_path(question.section, as: admin.id)
    click_link 'Edit'

    fill_in 'Position', with: '1'
    select concept.name, from: "Concept"
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
    concept = create :concept

    visit new_admin_section_question_path(section, question_type: 'Multiple Choice', as: admin.id)

    select 'Range', from: 'Question type'
    select concept.name, from: "Concept"

    sleep 0.5
    fill_in 'Position', with: '1'
    fill_in 'Minimum Value', with: '1'
    fill_in 'Maximum Value', with: '23'

    click_button 'Create Question'

    expect(page).to have_content("Question was successfully created.")
  end

end
