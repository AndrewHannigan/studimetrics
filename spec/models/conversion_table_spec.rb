require 'spec_helper'

describe ConversionTable do
  describe "ConversionTable#converted_score" do
    it "converts scores according to constant CONVERSION_TABLE" do
      expect(ConversionTable.converted_score("M", -1)).to eq 200
    end
  end
end
