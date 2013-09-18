require 'spec_helper'

describe ConceptHelper do
  describe '#concept_image' do
    it 'returns an image if one exists' do
      concept = Concept.new name: 'Absolute Value'
      expect(helper.concept_image(concept)).to include(helper.image_tag('/assets/concept_icons/absolute_value.png'))

      concept.name = 'Angles on a Plane'
      expect(helper.concept_image(concept)).to include(helper.image_tag('/assets/concept_icons/angles_on_a_plane.png'))
    end

    it 'returns a default image otherwise' do
      concept = Concept.new name: 'jasdjdkflsdf EJ ss'
      expect(helper.concept_image(concept)).to include(helper.image_tag('/assets/concept_icons/default.png'))
    end
  end

  describe '#concept_image_link' do
    it 'returns a concept image wrapped in a link' do
      helper.expects(:concept_image)
      concept =  build_stubbed :concept

      expect(helper.concept_image_link(concept)).to include('a href')
      expect(helper).to have_received(:concept_image).with(concept)
    end
  end

  describe '#concept_parent_path' do
    it 'returns the path to a parent concept if there is one' do
      parent_concept = create :concept, name: 'Reading Passage Questions'
      concept = create :concept, name: 'Inference'

      expect(helper.concept_parent_path(concept)).to include concept_path(parent_concept)
    end

    it 'returns the normal path otherwise' do
      concept = create :concept, name: 'awesome'
      expect(helper.concept_parent_path(concept)).to include concept_path(concept)
    end
  end
end
