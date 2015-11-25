class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :task, null: false
      t.string :tag, null: false, collation: 'ja_JP.UTF-8'
    end
  end
end
