module ConceptHelper
  def concept_image(concept)
    concept_name = concept.is_a?(String) ? concept : concept.name
    concept_file_name = underscored_name(concept_name)
    folder = 'concept_icons'
    image_name = "#{folder}/#{concept_file_name}.png"
    if !Rails.application.assets.find_asset image_name
      image_name = "#{folder}/default.png"
    end

    content_tag :span, class: 'concept-image hint--top hint--rounded', data: { hint: concept_name } do
      image_tag image_name
    end
  end

  def concept_image_link(concept)
    link_to concept_path(concept) do
      concept_image concept
    end
  end

  def underscored_name(name)
    name.titleize.gsub(/\//,' ').gsub(/\s+/, '_').underscore
  end
end
