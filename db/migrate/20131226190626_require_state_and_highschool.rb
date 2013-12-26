class RequireStateAndHighschool < ActiveRecord::Migration
  def up
    User.update_all highschool: '', state: ''

    change_column :users, :highschool, :string, null: false
    change_column :users, :state, :string, null: false 
  end
end
