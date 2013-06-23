class CreateRangeAnswers < ActiveRecord::Migration
  def change
    create_table :range_answers do |t|
      t.references :question, index: true
      t.decimal :min_value
      t.decimal :max_value

      t.timestamps
    end
  end
end
