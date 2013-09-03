class AddPdfToConceptVideoAndRemoveFromConcept < ActiveRecord::Migration
  def change
    remove_attachment :concepts, :pdf
    add_attachment :concept_videos, :pdf
  end

  def down
    remove_attachment :concepts_videos, :pdf
    add_attachment :concept, :pdf
  end
end
