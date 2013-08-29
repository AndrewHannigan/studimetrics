require 'spec_helper'

describe Concept do
  describe '.for_sidebar' do
    it 'gets a list of all concepts to display in the sidebar' do
      reading_subject = create :subject, name: 'Reading'
      concept1 = create :concept
      concept2 = create :concept, subject: reading_subject
      concept3 = create :concept, name: 'Vocabulary'

      sidebar_concepts = Concept.for_sidebar
      expect(sidebar_concepts).to include(concept1, concept3)
      expect(sidebar_concepts).to_not include(concept2)
    end
  end

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
