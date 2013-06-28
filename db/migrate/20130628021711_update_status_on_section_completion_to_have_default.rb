class UpdateStatusOnSectionCompletionToHaveDefault < ActiveRecord::Migration
  def up
    change_column :section_completions, :status, :string, null: false, default: "In-Progress"
  end

  def down
    change_column :section_completions, :status, :string, null: true
  end
end
