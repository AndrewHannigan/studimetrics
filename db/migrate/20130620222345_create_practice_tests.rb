class CreatePracticeTests < ActiveRecord::Migration
  def change
    create_table :practice_tests do |t|
      t.string :name
      t.references :book, index: true

      t.timestamps
    end
  end
end
