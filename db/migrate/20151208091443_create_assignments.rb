class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :task, null: false
      t.references :user, null: false
    end
  end
end
