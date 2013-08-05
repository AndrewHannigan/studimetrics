require 'csv'

class CollegeImporter
  attr_accessor :csv

  def initialize(file=Rails.root.join('db', 'colleges.csv'))
    self.csv = file
  end

  def import!
    CSV.foreach csv, headers: true do |row|
      college = College.create! name: row['College'], low_percentile_critical_reading: clean_na_values(row['Reading-25%']), high_percentile_critical_reading: clean_na_values(row['Reading-75%']), low_percentile_math: clean_na_values(row['Math-25%']), high_percentile_math: clean_na_values(row['Math-75%']), low_percentile_writing: clean_na_values(row['Writing-25%']), high_percentile_writing: clean_na_values(row['Writing-75%']), state: row['State']
    end
  end

  private

  def clean_na_values(value)
    return nil if value == 'NA'
    value
  end


end
