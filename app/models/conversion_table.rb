class ConversionTable
  CONVERSION_TABLE = YAML.load(File.read("config/conversion_table.yml"))

  def self.converted_score(subject_acronym, raw_score)
    CONVERSION_TABLE[subject_acronym][raw_score]
  end

end
