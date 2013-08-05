class AddScoresToColleges < ActiveRecord::Migration
  def change
    remove_column :colleges, :critical_reading, :integer
    remove_column :colleges, :math, :integer
    remove_column :colleges, :writing, :integer
    add_column :colleges, :low_percentile_critical_reading, :integer, null: false, default: 0
    add_column :colleges, :low_percentile_math, :integer, null: false, default: 0
    add_column :colleges, :low_percentile_writing, :integer, null: false, default: 0
    add_column :colleges, :high_percentile_critical_reading, :integer, null: false, default: 0
    add_column :colleges, :high_percentile_math, :integer, null: false, default: 0
    add_column :colleges, :high_percentile_writing, :integer, null: false, default: 0
    add_column :colleges, :state, :string
  end
end
