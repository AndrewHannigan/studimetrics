class RemoveUserIdFromUserResponses < ActiveRecord::Migration
  def up
    remove_column :user_responses, :user_id
  end

  def down
    add_column :user_responses, :user_id, :integer, null: false
    add_index :user_responses, :user_id
  end
end
