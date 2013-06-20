class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
      t.string :publisher
      t.date :publish_date

      t.timestamps
    end
  end
end
