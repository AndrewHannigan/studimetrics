class CreateFreeResponseAnswers < ActiveRecord::Migration
  def change
    create_table :free_response_answers do |t|
      t.references :question, index: true
      t.string :value
      t.timestamps
    end
  end
end
