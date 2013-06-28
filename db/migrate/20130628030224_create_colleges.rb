class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :name, null: false
      t.integer :critical_reading, null: false
      t.integer :math, null: false
      t.integer :writing, null: false

      t.timestamps
    end
  end
end
