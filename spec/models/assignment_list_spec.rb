require 'rails_helper'

describe AssignmentList do
  let(:list) { described_class.new(task.id) }
  let(:assignment) { Assignment.new(task: task, user: user) }
  let(:user) { User.new(id: 1) }
  let(:task) { Task.new(id: 2) }

  describe '#add_assignee' do
    context '初めて追加する場合' do
      it do
        list.add_assignee(user.id)
        expect(list).to eq([assignment])
      end
    end

    context '2回目に追加する場合' do
      it do
        list.add_assignee(user.id)
        list.add_assignee(user.id)
        expect(list).to eq([assignment])
      end
    end
  end

  describe '#remove_assignee' do
    it do
      list.add_assignee(user.id)
      list.remove_assignee(user.id)
      expect(list).to be_empty
    end
  end
end
