module ConceptHelper
  def concept_image(concept)
    folder = 'concept_icons'
    image_name = "#{folder}/#{concept.name.titleize.gsub(/\s+/, '').underscore}.png"
    if !Rails.application.assets.find_asset image_name
      image_name = "#{folder}/default.png"
    end

    content_tag :span, class: 'concept-image hint--top hint--rounded', data: { hint: concept.name } do
      image_tag image_name
    end
  end
end
