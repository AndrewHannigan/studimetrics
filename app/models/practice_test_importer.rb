class PracticeTestImporter
  attr_accessor :book

  def initialize(book)
    self.book = book
  end

  def import!
    (1..10).each do |i|
      PracticeTest.create! number: i, book: book
    end
  end
end
