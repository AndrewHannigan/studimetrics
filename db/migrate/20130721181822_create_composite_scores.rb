class CreateCompositeScores < ActiveRecord::Migration
  def up
    execute "create extension hstore"
    create_table :composite_scores do |t|
      t.references :user, index: true
      t.references :subject, index: true
      t.hstore :concepts, null: false, default: {}
      t.decimal :composite_score
    end
  end

  def down
    drop_table :composite_scores
    execute "drop extension hstore"
  end
end
