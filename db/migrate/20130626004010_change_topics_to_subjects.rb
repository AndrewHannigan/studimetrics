class ChangeTopicsToSubjects < ActiveRecord::Migration
  def change
    rename_column :sections, :topic_id, :subject_id
  end
end
