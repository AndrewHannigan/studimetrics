require 'spec_helper'

describe Book do
  describe 'validations' do
    it 'must use only accepted publishers' do
      book = FactoryGirl.build :book
      book.should be_valid

      book.publisher = 'fake'
      book.should_not be_valid
    end
  end
end
