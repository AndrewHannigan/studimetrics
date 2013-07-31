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

  describe "#question_count_by_subject" do
    it "returns the total number of questions for the practice test" do
      subj = create :subject, name: "Math"
      section = create :section, subject: subj
      question = create :question, section: section
      practice_test = question.section.practice_test

      expect(practice_test.question_count_by_subject(subj)).to eq 1
    end
  end

  describe '#first_section' do
    it 'returns the lowest numbered section in the test' do
      section1 = create :section, number: 2
      section2 = create :section, number: 1, practice_test: section1.practice_test, subject: section1.subject

      expect(section1.practice_test.first_section).to eq(section2)
    end
  end

  describe '#diagnostic?' do
    it 'returns true if the test is the lowest numbered test' do
      practice_test = create :practice_test
      expect(practice_test).to be_diagnostic
    end

    it 'returns false otherwise' do
      create :practice_test, number: 1
      practice_test2 = create :practice_test, number: 2

      expect(practice_test2).to_not be_diagnostic
    end
  end
end
