class RemoveSubjectFromTopics < ActiveRecord::Migration
  def change
    remove_column :topics, :subject
  end
end
