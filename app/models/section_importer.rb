require 'csv'

class SectionImporter
  attr_accessor :csv, :subjects

  def initialize(subjects, file=Rails.root.join('db', 'sections.csv'))
    self.csv = file
    self.subjects = subjects
  end

  def import!
    CSV.foreach csv, headers: true do |row|
      Section.create! practice_test_id: row['book_test_id'], number: row['section_number'], subject: subject_from_abbreviation(row['subject'])
    end
  end

  private

  def subject_from_abbreviation(abbreviation)
    subjects.detect { |s| s.name.split(' ').map(&:first).join == abbreviation }
  end
end
