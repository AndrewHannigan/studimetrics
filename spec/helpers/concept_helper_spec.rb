require 'spec_helper'

describe ConceptHelper do
  describe '#concept_image' do
    it 'returns an image if one exists' do
      concept = Concept.new name: 'Absolute Value'
      expect(helper.concept_image(concept)).to include(helper.image_tag('concept_icons/absolute_value.png'))

      concept.name = 'Angles on a Plane'
      expect(helper.concept_image(concept)).to include(helper.image_tag('concept_icons/angles_on_a_plane.png'))
    end

    it 'returns a default image otherwise' do
      concept = Concept.new name: 'jasdjdkflsdf EJ ss'
      expect(helper.concept_image(concept)).to include(helper.image_tag('concept_icons/default.png'))
    end
  end
end
