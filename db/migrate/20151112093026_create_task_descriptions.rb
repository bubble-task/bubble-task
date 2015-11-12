class CreateTaskDescriptions < ActiveRecord::Migration
  def change
    create_table :task_descriptions do |t|
      t.references :task, null: false
      t.text :content, null: false
    end
  end
end
