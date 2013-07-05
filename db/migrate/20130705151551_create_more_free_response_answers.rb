class CreateMoreFreeResponseAnswers < ActiveRecord::Migration
  def change
    create_table :free_response_answers do |t|
      t.string :value
      t.references :question, index: true
      t.timestamps
    end
  end
end
