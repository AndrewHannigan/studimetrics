require 'spec_helper'

describe PracticeTest do
  describe 'validations' do
    describe 'number' do
      it 'is invalid with non-unique number per book' do
        practice_test = FactoryGirl.create :practice_test
        other_test = PracticeTest.new number: practice_test.number, book_id: practice_test.book_id

        other_test.valid?

        expect(other_test.errors).to include(:number)
      end

      it 'is valid with non-unique number in a different book' do
        practice_test = FactoryGirl.create :practice_test
        book2 = FactoryGirl.create :book
        other_test = PracticeTest.new number: practice_test.number, book_id: book2.id

        other_test.valid?

        expect(other_test.errors).to_not include(:number)
      end
    end
  end

  describe '#book' do
    it 'returns a NullBook if book_id is not set' do
      practice_test = PracticeTest.new
      expect(practice_test.book).to be_kind_of(NullBook)
    end
  end

  describe '#name' do
    it 'returns a string representation of a test' do
      test = PracticeTest.new number: 2
      expect(test.name).to eq('Test 2')
    end
  end
end
