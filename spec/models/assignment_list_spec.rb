require 'rails_helper'

describe AssignmentList do
  let(:empty_list) { described_class.new }
  let(:assignment) { Assignment.new(task: task, user: user) }
  let(:user) { User.new(id: 1) }
  let(:task) { Task.new(id: 2) }

  describe '#add' do

    context '初めて追加する場合' do
      it do
        new_list = empty_list.add(assignment)
        expect(new_list).to eq([assignment])
      end
    end

    context '2回目に追加する場合' do
      it do
        first_list = empty_list.add(assignment)
        second_list = first_list.add(assignment)
        expect(second_list).to eq([assignment])
      end
    end
  end

  describe '#remove' do
    it do
      assignment_list = empty_list.add(assignment)
      abandoned_list = assignment_list.remove(assignment)
      expect(abandoned_list).to be_empty
    end
  end
end
