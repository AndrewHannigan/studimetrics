class AddPositionToFocusRanks < ActiveRecord::Migration
  def change
    add_column :focus_ranks, :position, :integer
  end
end
