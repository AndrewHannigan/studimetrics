class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.references :practice_test, index: true
      t.references :topic, index: true

      t.timestamps
    end
  end
end
