class RemoveBadHigschoolFromUsers < ActiveRecord::Migration
  def change
    # this was only needed to remove bad development state... was never live in production
    # remove_column :users, :highschool, :string
  end
end
