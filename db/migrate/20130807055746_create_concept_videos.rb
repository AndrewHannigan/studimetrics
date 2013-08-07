class CreateConceptVideos < ActiveRecord::Migration
  def change
    create_table :concept_videos do |t|
      t.string :caption
      t.string :video_link
      t.references :concept, index: true

      t.timestamps
    end
  end
end
