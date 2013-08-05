class Importer
  attr_accessor :book, :practice_tests

  def import!
    Book.transaction do
      self.book = Book.create! name: 'College Board 2009', publisher: 'College Board', publish_date:'2009-01-01'

      puts "creating tests"
      self.practice_tests = PracticeTestImporter.new(book).import!

      puts "creating subjects"
      subjects = ["Math", "Writing", "Critical Reading"].map do |subject|
        Subject.create! name: subject
      end

      puts "creating sections"
      SectionImporter.new(subjects).import!

      puts "creating concepts"
      ConceptImporter.new(subjects).import!

      puts "creating questions"
      QuestionImporter.new.import!
    end
  end

end
