class ReplaceNameWithNumberInPracticeTests < ActiveRecord::Migration
  def change
    remove_column :practice_tests, :name, :string
    add_column :practice_tests, :number, :integer, default: 0, null: false
  end
end
