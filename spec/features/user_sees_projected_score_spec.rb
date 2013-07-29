require 'spec_helper'

feature 'user logs in' do

  scenario 'sees projected scores' do
    user = create :user

    math = create :subject, name: "Math"
    critical_reading = create :subject, name: "Critical Reading"
    writing = create :subject, name: "Writing"

    math_composite_score = create :composite_score, subject: math, user: user
    writing_composite_score = create :composite_score, subject: critical_reading, user: user
    reading_composite_score = create :composite_score, subject: writing, user: user

    ConversionTable.expects(:converted_score).with("M", 0).returns(500)
    ConversionTable.expects(:converted_score).with("W", 0).returns(600)
    ConversionTable.expects(:converted_score).with("CR", 0).returns(700)

    visit root_path as: user.id

    expect(page).to have_css "div.math-score div.number", text: "500"
    expect(page).to have_css "div.writing-score div.number", text: "600"
    expect(page).to have_css "div.reading-score div.number", text: "700"
  end

end
