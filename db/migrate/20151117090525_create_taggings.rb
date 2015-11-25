class CreateTaggings < ActiveRecord::Migration
  def change
    tag_column_spec = { null: false }
    tag_column_spec.merge!(collation: 'ja_JP.UTF-8') unless ENV['CI']
    create_table :taggings do |t|
      t.references :task, null: false
      t.string :tag, tag_column_spec
    end
  end
end
