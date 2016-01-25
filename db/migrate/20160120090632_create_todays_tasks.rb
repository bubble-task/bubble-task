class CreateTodaysTasks < ActiveRecord::Migration
  def change
    create_table :todays_tasks do |t|
      t.references :task, null: false
      t.references :user, null: false
    end
  end
end
