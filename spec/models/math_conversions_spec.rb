require 'spec_helper'

describe MathConversions do
  describe 'number_to_float' do
    it 'parses a fraction and returns a float' do
      expect(MathConversions.number_to_float '3/2').to eq(1.5)
    end

    it 'parses a whole number and returns a float' do
      expect(MathConversions.number_to_float '7').to eq(7.0)
    end

    it 'parses decimals and rturns a float' do
      expect(MathConversions.number_to_float '0.33').to eq(0.33)
    end
  end
end
