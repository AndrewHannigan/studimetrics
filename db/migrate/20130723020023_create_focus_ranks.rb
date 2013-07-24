class CreateFocusRanks < ActiveRecord::Migration
  def change
    create_table :focus_ranks do |t|
      t.references :user, index: true
      t.references :concept, index: true
      t.integer :correct, default: 0, null: false
      t.integer :incorrect, default: 0, null: false
      t.decimal :average_time, default: 0, null: false
      t.decimal :score
      t.timestamps
    end
  end
end
