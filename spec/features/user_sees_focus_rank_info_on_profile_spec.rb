require 'spec_helper'

feature 'user visits profile' do

  scenario 'with no focus rank' do
    user = create :user
    visit profile_path as: user.id

    expect(page).to have_content(I18n.t 'profile.concept_progress.no_focus_rank_message', practice_test_link: 'practice test')
  end

  scenario 'sees focus rank information' do
    user = create :user

    math = create :subject, name: "Math"
    critical_reading = create :subject, name: "Reading"

    algebra = create :concept, name: "Algebra", subject_id: math.id
    arithmetic = create :concept, name: "Arithmetic", subject_id: math.id

    interpretation = create :concept, name: "Interpretation", subject_id: critical_reading.id
    themes = create :concept, name: "Themes", subject_id: critical_reading.id

    algebra_focus_rank = create :focus_rank, user: user, concept: algebra, score: 10, position_delta: 2, accuracy_delta: 20, position: 1
    arithmetic_focus_rank = create :focus_rank, user: user, concept: arithmetic, score: 9, position_delta: -1, accuracy_delta: -5, position: 2

    interpretation_focus_rank = create :focus_rank, user: user, concept: interpretation, score: 8, position_delta: 1, accuracy_delta: 10, position: 3
    themes_focus_rank = create :focus_rank, user: user, concept: themes, position_delta: -1, score: 7, accuracy_delta: -3, position: 4

    FocusRank.any_instance.stubs(:accuracy).returns(55)
    FocusRank.any_instance.stubs(:percentage_complete).returns(40)
    FocusRank.any_instance.stubs(:frequency_for_user).returns(20)

    visit profile_path as: user.id

    expect(focus_rank_on_page(algebra_focus_rank).find("td.position i.ss-icon").text).to eq "up"
    expect(focus_rank_on_page(themes_focus_rank).find("td.position i.ss-icon").text).to eq "down"
    expect(focus_rank_on_page(themes_focus_rank).find("td.position span").text).to eq "4"
  end

  scenario "sees focus rank when the deltas are null" do
    user = create :user

    math = create :subject, name: "Math"
    critical_reading = create :subject, name: "Reading"

    algebra = create :concept, name: "Algebra", subject_id: math.id
    arithmetic = create :concept, name: "Arithmetic", subject_id: math.id

    interpretation = create :concept, name: "Interpretation", subject_id: critical_reading.id
    themes = create :concept, name: "Themes", subject_id: critical_reading.id

    algebra_focus_rank = create :focus_rank, user: user, concept: algebra, score: 10, position_delta: nil, accuracy_delta: nil, position: 1
    arithmetic_focus_rank = create :focus_rank, user: user, concept: arithmetic, score: 9, position_delta: nil, accuracy_delta: nil, position: 2

    interpretation_focus_rank = create :focus_rank, user: user, concept: interpretation, score: 8, position_delta: nil, accuracy_delta: nil, position: 3
    themes_focus_rank = create :focus_rank, user: user, concept: themes, position_delta: nil, score: 7, accuracy_delta: nil, position: 4

    FocusRank.any_instance.stubs(:accuracy).returns(55)
    FocusRank.any_instance.stubs(:percentage_complete).returns(40)
    FocusRank.any_instance.stubs(:frequency_for_user).returns(20)

    visit profile_path as: user.id

    expect(focus_rank_on_page(themes_focus_rank).find("td.position span").text).to eq "4"
  end
end

def focus_rank_on_page(focus_rank)
  find("[data-id='focus_rank-#{focus_rank.id}']")
end
