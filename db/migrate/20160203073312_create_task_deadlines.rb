class CreateTaskDeadlines < ActiveRecord::Migration
  def change
    create_table :task_deadlines do |t|
      t.references :task, null: false
      t.datetime :datetime, null: false
    end
  end
end
