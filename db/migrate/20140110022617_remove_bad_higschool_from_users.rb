class RemoveBadHigschoolFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :highschool, :string
  end
end
