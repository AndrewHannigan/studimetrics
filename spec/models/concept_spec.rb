require 'spec_helper'

describe Concept do
  describe '#underscored_concept_name' do
    it 'returns the underscored version of the concept name' do
      concept = Concept.new name: 'Angles on a plane'
      expect(concept.underscored_concept_name).to eq 'angles_on_a_plane'

      concept = Concept.new name: 'Factors/Factoring/Foiling'
      expect(concept.underscored_concept_name).to eq 'factors_factoring_foiling'

      concept = Concept.new name: 'Neither/Nor & Either/Or'
      expect(concept.underscored_concept_name).to eq 'neither_nor_&_either_or'
    end
  end
end
