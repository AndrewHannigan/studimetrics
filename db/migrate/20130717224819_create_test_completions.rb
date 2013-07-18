class CreateTestCompletions < ActiveRecord::Migration
  def change
    create_table :test_completions do |t|
      t.references :user, index: true
      t.references :practice_test, index: true
      t.integer :raw_math_score
      t.integer :raw_critical_reading_score
      t.integer :raw_writing_score
      t.integer :percentage_complete, default: 0, null: false
    end
  end
end
