class DropTodaysTasks < ActiveRecord::Migration
  def up
    drop_table :todays_tasks if ActiveRecord::Base.connection.table_exists?(:todays_tasks)
  end
end
