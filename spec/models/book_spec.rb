require 'spec_helper'

describe Book do
  describe 'validations' do
    it 'must use only accepted publishers' do
      book = FactoryGirl.build :book
      expect(book).to be_valid

      book.publisher = 'fake'
      expect(book).to_not be_valid
    end
  end
end
