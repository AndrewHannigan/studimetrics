require 'spec_helper'

feature 'User clicks next section' do
  scenario 'sees the next section in the test' do
    user = create :user
    section_completion = create :section_completion, status: 'Completed', user: user
    next_section = create :section, practice_test: section_completion.section.practice_test

    visit section_completion_path section_completion, as: user.id
    find('.next-section').click

    expect(current_url).to eq(new_section_completion_url(section_id: next_section.id))
  end

  scenario 'sees the first section in the test if there is no next' do
    user = create :user
    section_completion = create :section_completion, status: 'Completed', user: user
    section_completion.section.update_attributes number: 2
    next_section = create :section, practice_test: section_completion.section.practice_test, number: 1

    visit section_completion_path section_completion, as: user.id
    find('.next-section').click

    expect(current_url).to eq(new_section_completion_url(section_id: next_section.id))
  end
end
