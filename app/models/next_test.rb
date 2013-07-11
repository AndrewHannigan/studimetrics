class NextTest
  attr_accessor :user, :current_practice_test

  def initialize(user, practice_test)
    self.user = user
    self.current_practice_test = practice_test
  end

  def practice_test
    if TestProgress.new(user: user, practice_test: current_practice_test).complete?
      current_practice_test.book.practice_tests.where("number > ?", current_practice_test.number).order("number asc").first
    else
      current_practice_test
    end
  end
end
