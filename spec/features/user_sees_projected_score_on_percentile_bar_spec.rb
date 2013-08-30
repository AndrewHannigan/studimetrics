require 'spec_helper'

feature 'user logs in' do

  scenario 'sees projected scores on percentile bar' do
    user = create :user

    math = create :subject, name: "Math"
    critical_reading = create :subject, name: "Reading"
    writing = create :subject, name: "Writing"

    math_composite_score = create :composite_score, subject: math, user: user
    writing_composite_score = create :composite_score, subject: critical_reading, user: user
    reading_composite_score = create :composite_score, subject: writing, user: user

    ConversionTable.stubs(:converted_score).with("M", 0).returns(500)
    ConversionTable.stubs(:converted_score).with("W", 0).returns(600)
    ConversionTable.stubs(:converted_score).with("R", 0).returns(700)

    visit profile_path as: user.id

    expect(page).to have_css "div.percentile-bar.math span.bar span.indicator", text: "500"
    expect(page).to have_css "div.percentile-bar.writing span.bar span.indicator", text: "600"
    expect(page).to have_css "div.percentile-bar.reading span.bar span.indicator", text: "700"
  end

end
