class AddUserToUserResponses < ActiveRecord::Migration
  def change
    add_column :user_responses, :user_id, :integer, null: false, index: true
  end
end
