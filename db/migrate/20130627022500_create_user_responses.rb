class CreateUserResponses < ActiveRecord::Migration
  def change
    create_table :user_responses do |t|
      t.references :question, index: true
      t.references :section_completion, index: true
      t.string :value
      t.boolean :correct
      t.integer :time

      t.timestamps
    end
  end
end
