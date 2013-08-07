class AddOrdinalToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :ordinal, :integer, null: false, default: 0
  end
end
