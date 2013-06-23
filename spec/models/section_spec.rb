require 'spec_helper'

describe Section do
  describe 'validations' do
    it 'must have a unique name per practice test id' do
     section = FactoryGirl.create :section
     expect {
      FactoryGirl.create! :section, practice_test: section.practice_test
     }.to raise_error
    end
  end
end
