require 'spec_helper'

describe Concept do
  describe '.filtered' do
    it 'gets a list of all concepts to display in the sidebar' do
      reading_subject = create :subject, name: 'Reading'
      concept1 = create :concept
      concept2 = create :concept, subject: reading_subject
      concept3 = create :concept, name: 'Vocabulary'

      sidebar_concepts = Concept.filtered
      expect(sidebar_concepts).to include(concept1, concept3)
      expect(sidebar_concepts).to_not include(concept2)
    end
  end

  describe '#has_parent_concept?' do
    it 'returns true if present' do
      concept = Concept.new
      concept.expects(:parent_concept).returns(Concept.new)

      expect(concept).to have_parent_concept
    end

    it 'returns false otherwise' do
      concept = Concept.new
      concept.expects(:parent_concept).returns(nil)

      expect(concept).to_not have_parent_concept
    end
  end

  describe '#parent_concept' do
    it 'returns a parent concept if its included in PARENT_CONCEPTS' do
      parent_concept = create :concept, name: 'Reading Passage Questions'
      concept = Concept.new name: 'Inference'

      expect(concept.parent_concept).to eq parent_concept
    end

    it 'returns nil otherwise' do
      concept = Concept.new

      expect(concept.parent_concept).to be_nil
    end
  end
end
