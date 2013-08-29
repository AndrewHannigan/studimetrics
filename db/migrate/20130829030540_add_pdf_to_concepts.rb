class AddPdfToConcepts < ActiveRecord::Migration
  def change
    add_attachment :concepts, :pdf
  end
end
