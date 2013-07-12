class AddScoreableToSectionCompletion < ActiveRecord::Migration
  def change
    add_column :section_completions, :scoreable, :boolean, null: false, default: false
    add_index :section_completions, :scoreable
  end
end
