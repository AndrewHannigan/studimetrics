module ConceptHelper
  def concept_image(concept)
    folder = 'concept_icons'
    image_name = "#{folder}/#{concept.name.titleize.gsub(/\s+/, '').underscore}.png"
    if !Rails.application.assets.find_asset image_name
      image_name = "#{folder}/default.png"
    end
    image_tag image_name, class: 'concept-image'
  end
end
