require 'spec_helper'

describe ConversionTable do
  describe "ConversionTable#converted_score" do
    it "converts scores according to constant CONVERSION_TABLE" do
      subj = create :subject, name: "Math"
      ConversionTable::CONVERSION_TABLE = {subj.name => {-1 => 300}}

      expect(ConversionTable.converted_score(subj, -1)).to eq 300
    end
  end
end
