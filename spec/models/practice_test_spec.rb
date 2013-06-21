require 'spec_helper'

describe PracticeTest do
  describe '#book' do
    it 'returns a NullBook if book_id is not set' do
      practice_test = PracticeTest.new
      expect(practice_test.book).to be_kind_of(NullBook)
    end
  end
end
