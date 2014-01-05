class RequireStateAndHighschool < ActiveRecord::Migration
  def up
    User.update_all highschool: ''
    User.where(state: nil).update_all state: ''
    change_column :users, :highschool, :string, null: false
    change_column :users, :state, :string, null: false 
  end

  def down
    change_column :users, :highschool, :string
    change_column :users, :state, :string 
  end
end
