class ChangeDefaultOnSectionCompletionStatus < ActiveRecord::Migration
  def up
    change_column :section_completions, :status, :string, null: false, default: "Not Started"
  end

  def down
    change_column :section_completions, :status, :string, null: false, default: "In-Progress"
  end
end
