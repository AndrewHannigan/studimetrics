class AddUserIdToSectionCompletions < ActiveRecord::Migration
  def change
    add_column :section_completions, :user_id, :integer, null: false
    add_index :section_completions, :user_id
  end
end
