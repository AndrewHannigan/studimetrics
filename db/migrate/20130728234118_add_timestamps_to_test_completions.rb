class AddTimestampsToTestCompletions < ActiveRecord::Migration
  def change
    add_column :test_completions, :created_at, :datetime
    add_column :test_completions, :updated_at, :datetime
  end
end
