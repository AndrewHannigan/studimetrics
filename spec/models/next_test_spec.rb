require 'spec_helper'

describe NextTest do
  describe '#practice_test' do
    it 'returns the next lowest numbered test' do
      test1 = create :practice_test, number: 1
      test2 = create :practice_test, number: 2, book: test1.book
      user = User.new
      next_test = NextTest.new user, test1
      TestProgress.any_instance.stubs(:complete?).returns(true)

      expect(next_test.practice_test).to eq test2
    end

    it 'returns the current test if the test is not complete' do
      test1 = create :practice_test, number: 1
      create :practice_test, number: 2, book: test1.book
      user = User.new
      next_test = NextTest.new user, test1
      TestProgress.any_instance.stubs(:complete?).returns(false)

      expect(next_test.practice_test).to eq test1
    end
  end
end
