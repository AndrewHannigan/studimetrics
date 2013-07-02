class ConvertUserResponseTimeToDecimal < ActiveRecord::Migration
  def change
    change_column :user_responses, :time, :decimal, default: 0
  end
end
