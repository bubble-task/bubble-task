class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :task, null: false
      t.string :tag, null: false
    end

    unless ENV['CI']
      execute <<-SQL
        ALTER TABLE taggings ALTER COLUMN tag TYPE VARCHAR COLLATE "ja_JP.UTF-8";
      SQL
    end
  end
end
