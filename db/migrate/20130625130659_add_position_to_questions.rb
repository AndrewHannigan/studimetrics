class AddPositionToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :position, :integer, index: true
  end
end
