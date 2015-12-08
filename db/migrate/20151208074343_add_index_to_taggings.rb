class AddIndexToTaggings < ActiveRecord::Migration
  def change
    add_index(:taggings, [:tag, :task_id], unique: true)
  end
end
