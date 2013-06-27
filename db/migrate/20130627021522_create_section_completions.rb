class CreateSectionCompletions < ActiveRecord::Migration
  def change
    create_table :section_completions do |t|
      t.references :section, index: true
      t.string :status

      t.timestamps
    end
  end
end
