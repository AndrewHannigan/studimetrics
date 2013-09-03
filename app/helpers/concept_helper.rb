module ConceptHelper
  def concept_image(concept)
    concept_name = concept.is_a?(String) ? concept : concept.name
    image_name = Concept.image_path concept

    content_tag :span, class: 'concept-image hint--top hint--rounded', data: { hint: concept_name } do
      image_tag image_name
    end
  end

  def concept_image_link(concept)
    link_to concept_path(concept) do
      concept_image concept
    end
  end

end
