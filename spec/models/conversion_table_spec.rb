require 'spec_helper'

describe ConversionTable do
  describe "ConversionTable#converted_score" do
    it "converts scores according to constant CONVERSION_TABLE" do
      ConversionTable::CONVERSION_TABLE = {"M" => {-1 => 300}}

      expect(ConversionTable.converted_score("M", -1)).to eq 300
    end
  end
end
