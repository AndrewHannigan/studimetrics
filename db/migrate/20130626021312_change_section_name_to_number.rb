class ChangeSectionNameToNumber < ActiveRecord::Migration
  def change
    remove_column :sections, :name, :string
    add_column :sections, :number, :integer, default: 0, null: false
  end
end
