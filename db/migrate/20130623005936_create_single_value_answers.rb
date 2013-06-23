class CreateSingleValueAnswers < ActiveRecord::Migration
  def change
    create_table :single_value_answers do |t|
      t.references :question, index: true
      t.string :value

      t.timestamps
    end
  end
end
