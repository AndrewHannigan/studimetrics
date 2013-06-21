require 'spec_helper'

describe NullBook do
  describe 'name' do
    it 'returns unassigned' do
      book = NullBook.new
      expect(book.name).to eq('Unassigned')
    end
  end
end
