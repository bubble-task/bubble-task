require 'rails_helper'

describe AssignmentList do
  let(:list) { described_class.new }
  let(:assignment) { Assignment.new(task: task, user: user) }
  let(:user) { User.new(id: 1) }
  let(:task) { Task.new(id: 2) }

  describe '#add' do
    context '初めて追加する場合' do
      it do
        list.add(assignment)
        expect(list).to eq([assignment])
      end
    end

    context '2回目に追加する場合' do
      it do
        list.add(assignment)
        list.add(assignment)
        expect(list).to eq([assignment])
      end
    end
  end

  describe '#remove' do
    it do
      list.add(assignment)
      list.remove(assignment)
      expect(list).to be_empty
    end
  end
end
