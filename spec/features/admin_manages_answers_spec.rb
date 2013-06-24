require 'spec_helper'

feature 'Admin manages answers' do
  context "single value answers" do
    scenario 'adds answer' do
      admin = FactoryGirl.create :admin
      question = FactoryGirl.create :question, question_type: "Single Value"

      visit admin_section_question_path(section_id: question.section.id, id: question.id, as: admin.id)
      click_link 'Edit Answers'
      click_link 'New Single Value Answer'

      fill_in 'Answer', with: 'A'

      click_button 'Create Single value answer'

      expect(page).to have_content("Single value answer was successfully created.")
    end

    scenario 'edits answer' do
      admin = FactoryGirl.create :admin
      question = FactoryGirl.create :question, question_type: "Single Value"
      answer = FactoryGirl.create :single_value_answer, question_id: question.id, value: "A"

      visit admin_section_question_path(section_id: question.section.id, id: question.id, as: admin.id)

      click_link 'Edit Answers'
      click_link 'Edit'

      fill_in 'Answer', with: 'B'

      click_button 'Update Single value answer'

      expect(page).to have_content("Single value answer was successfully updated.")
    end
  end

  context "range value answers" do
    scenario "adds answer" do
      admin = FactoryGirl.create :admin
      question = FactoryGirl.create :question, question_type: "Range"

      visit admin_section_question_path(section_id: question.section.id, id: question.id, as: admin.id)
      click_link 'Edit Answers'
      click_link 'New Range Answer'

      fill_in 'Minimum Value', with: '1'
      fill_in "Maximum Value", with: '10'

      click_button 'Create Range answer'

      expect(page).to have_content("Range answer was successfully created.")
    end
  end
end
