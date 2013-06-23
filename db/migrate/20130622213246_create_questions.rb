class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name
      t.string :question_type
      t.references :section, index: true

      t.timestamps
    end
  end
end
