class Importer
  attr_accessor :book, :practice_tests

  def import!
    Book.transaction do
      self.book = Book.create! name: 'College Board 2009', publisher: 'College Board', publish_date:'2009-01-01'

      puts "creating tests"
      self.practice_tests = PracticeTestImporter.new(book).import!

      puts "creating subjects"
      subjects = []
      ["Math", "Critical Reading", "Writing"].each_with_index do |subject, i|
        subjects << Subject.create!(name: subject, ordinal: i+1)
      end

      puts "creating sections"
      SectionImporter.new(subjects).import!

      puts "creating concepts"
      ConceptImporter.new(subjects).import!

      puts "creating questions"
      QuestionImporter.new.import!

      puts "creating colleges"
      CollegeImporter.new.import!
    end
  end

end
