require 'spec_helper'

feature 'User clicks next test' do
  scenario 'sees the first section for the next test' do
    user = create :user
    section_completion1 = create :section_completion, status: 'Completed', user: user
    section_completion2 = create :section_completion, user: user
    section_completion2.section.practice_test.update_attributes book_id: section_completion1.section.practice_test.book_id
    TestProgress.any_instance.stubs(:complete?).returns(true)

    visit section_completion_path section_completion1, as: user.id
    find('.next-test').click

    expect(current_url).to eq(new_section_completion_url(section_id: section_completion2.section))
  end
end
