class RemoveFreeResponseAnswers < ActiveRecord::Migration
  def up
    drop_table :free_response_answers
  end

  def down
    create_table :free_response_answers do |t|
      t.references :question, index: true
      t.string :value
      t.timestamps
    end
  end
end
