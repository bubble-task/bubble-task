require 'rails_helper'

describe TodaysTaskList do
  let(:list) { described_class.new(user_id, initial_tasks) }
  let(:user_id) { 123 }
  let(:task_id) { 100 }

  context '初期状態が空の場合' do
    let(:initial_tasks) { [] }

    describe '#add_task' do
      it do
        list.add_task(task_id)
        expect(list).to eq([TodaysTask.new(task_id: task_id, user_id: user_id)])
      end
    end
  end

  context '1つタスクがある場合' do
    let(:initial_tasks) { [TodaysTask.new(task_id: 1, user_id: user_id)] }

    describe '#add_task' do
      it do
        list.add_task(task_id)
        expected_tasks = initial_tasks + [TodaysTask.new(task_id: task_id, user_id: user_id)]
        expect(list).to eq(expected_tasks)
      end
    end
  end
end
