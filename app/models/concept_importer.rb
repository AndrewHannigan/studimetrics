require 'csv'

class ConceptImporter
  attr_accessor :csv, :subjects

  def initialize(subjects, file=Rails.root.join('db', 'concepts.csv'))
    self.csv = file
    self.subjects = subjects
  end

  def import!
    CSV.foreach csv, headers: true do |row|
      Concept.create! name: row['TOPIC NAME'], subject: subject_from_abbreviation(row['Section'])
    end
  end

  private

  def subject_from_abbreviation(abbreviation)
    subjects.detect { |s| s.name.split(' ').map(&:first).join == abbreviation }
  end
end
