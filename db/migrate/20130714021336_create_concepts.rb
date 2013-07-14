class CreateConcepts < ActiveRecord::Migration
  def change
    create_table :concepts do |t|
      t.string :name, null: false
      t.references :subject, null: false

      t.timestamps
    end
  end
end
