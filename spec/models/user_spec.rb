require 'rails_helper'

describe User do
  let(:empty_assignment_list) { AssignmentList.new }
  let(:user) { User.new(id: 1) }
  let(:task) { Task.new(id: 2) }

  describe 'タスクを担当する' do
    it do
      new_assignment_list = user.take_task(task, empty_assignment_list)
      expect(new_assignment_list).to include(Assignment.new(task: task, user: user))
    end
  end

  describe 'タスクの担当を解除する' do
    it do
      assignment_list = user.take_task(task, empty_assignment_list)
      new_assignment_list = user.abandon_task(task, assignment_list)
      expect(new_assignment_list).to_not include(Assignment.new(task: task, user: user))
    end
  end
end
