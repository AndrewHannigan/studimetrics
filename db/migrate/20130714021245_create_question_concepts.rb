class CreateQuestionConcepts < ActiveRecord::Migration
  def change
    create_table :question_concepts do |t|
      t.references :question, index: true
      t.references :concept, index: true

      t.timestamps
    end
  end
end
