class CreatePersonalTasks < ActiveRecord::Migration
  def change
    create_table :personal_tasks do |t|
      t.references :task, null: false
      t.references :user, null: false
    end
  end
end
