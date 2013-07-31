require 'spec_helper'

feature 'sees projected scores' do

  scenario 'sees projected scores' do
    user = create :user

    math = create :subject, name: "Math"
    critical_reading = create :subject, name: "Critical Reading"
    writing = create :subject, name: "Writing"

    math_composite_score = create :composite_score, subject: math, user: user
    writing_composite_score = create :composite_score, subject: critical_reading, user: user
    reading_composite_score = create :composite_score, subject: writing, user: user

    ConversionTable.stubs(:converted_score).with("M", 0).returns(500)
    ConversionTable.stubs(:converted_score).with("W", 0).returns(600)
    ConversionTable.stubs(:converted_score).with("CR", 0).returns(700)

    visit profile_path as: user.id

    expect(page).to have_css ".math-score .number", text: "500"
    expect(page).to have_css ".writing-score .number", text: "600"
    expect(page).to have_css ".reading-score .number", text: "700"
  end

  scenario 'doesnt see project scores on landing pages' do
    user = create :user
    visit root_path as: user.id

    expect(page).to_not have_css ".math-score .number"
    expect(page).to_not have_css ".writing-score .number"
    expect(page).to_not have_css ".reading-score .number"
  end

end
