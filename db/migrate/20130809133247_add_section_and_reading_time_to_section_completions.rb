class AddSectionAndReadingTimeToSectionCompletions < ActiveRecord::Migration
  def change
    add_column :section_completions, :section_time, :decimal, null: false, default: 0
    add_column :section_completions, :reading_time, :decimal, null: false, default: 0
  end
end
