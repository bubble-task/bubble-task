require 'rails_helper'

describe User do
  describe 'タスクを担当する' do
    it do
      user = User.new(id: 1)
      task = Task.new(id: 1)
      new_assignment_list = user.take_task(task, [])
      expect(new_assignment_list).to include(Assignment.new(user: user, task: task))
    end
  end

  describe '既に担当している場合は再度担当しない' do
    it do
      user = User.new(id: 1)
      task = Task.new(id: 1)
      first_assignment_list = user.take_task(task, [])
      second_assignment_list = user.take_task(task, first_assignment_list)
      expect(second_assignment_list).to eq(first_assignment_list)
    end
  end
end
