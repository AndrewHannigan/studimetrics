require 'spec_helper'

feature 'Admin manages concepts' do
  scenario 'adds concept' do
    admin = FactoryGirl.create :admin
    subj = create  :subject

    visit admin_concepts_path as: admin.id

    click_link 'New Concept'

    fill_in 'Name', with: 'Cool Concept'
    select subj.name, from: 'Subject'

    click_button 'Create Concept'

    expect(page).to have_content("Concept was successfully created.")
  end

  scenario 'edits concept' do
    admin = create :admin
    concept = create :concept

    visit admin_concept_path(concept, as: admin.id)
    click_link 'Edit Concept'

    fill_in 'Name', with: 'Cooler Concept'

    click_button 'Update Concept'

    expect(page).to have_content("Concept was successfully updated.")
  end
end

