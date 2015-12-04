class CreateCompletedTasks < ActiveRecord::Migration
  def change
    create_table :completed_tasks do |t|
      t.references :task, null: false
      t.datetime :completed_at, null: false
    end
  end
end
