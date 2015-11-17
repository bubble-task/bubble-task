class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :task, null: false
      t.references :tag, null: false
    end
  end
end
