class CreateMultipleChoiceAnswers < ActiveRecord::Migration
  def up
    drop_table :single_value_answers
    create_table :multiple_choice_answers do |t|
      t.references :question, index: true
      t.string :value

      t.timestamps
    end
  end

  def down
    drop_table :multiple_choice_answers
    create_table :single_value_answers do |t|
      t.references :question, index: true
      t.string :value

      t.timestamps
    end
  end
end

