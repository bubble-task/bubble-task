require 'rails_helper'

describe AssignmentList do
  describe '#add' do
    let(:empty_list) { described_class.new }
    let(:assignment) { Assignment.new(task: task, user: user) }
    let(:user) { User.new(id: 1) }
    let(:task) { Task.new(id: 2) }

    context '初めて追加する場合' do
      it do
        new_list = empty_list.add(assignment)
        expect(new_list).to eq([assignment])
      end
    end

    context '2回目に追加する場合' do
      it do
        new_list = empty_list
                     .add(assignment)
                     .add(assignment)
        expect(new_list).to eq([assignment])
      end
    end
  end
end
