class AddTestCompletionIdToSectionCompletions < ActiveRecord::Migration
  def change
    add_column :section_completions, :test_completion_id, :integer
    add_index :section_completions, :test_completion_id
  end
end
