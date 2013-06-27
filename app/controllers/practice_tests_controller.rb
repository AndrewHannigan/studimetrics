class PracticeTestsController < ApplicationController
  before_filter :authorize

  def index
    @practice_tests = PracticeTest.all
  end
end
