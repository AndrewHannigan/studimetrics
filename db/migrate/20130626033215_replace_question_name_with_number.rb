class ReplaceQuestionNameWithNumber < ActiveRecord::Migration
  def change
    remove_column :questions, :name, :string
  end
end
