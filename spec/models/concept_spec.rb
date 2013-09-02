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
end
