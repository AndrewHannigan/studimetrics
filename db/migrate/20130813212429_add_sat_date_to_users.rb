class AddSatDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sat_date, :date
  end
end
