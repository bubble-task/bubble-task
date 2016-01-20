require 'rails_helper'

describe TodaysTaskList do
  let(:list) { described_class.new(user_id) }
  let(:user_id) { 123 }
  let(:task_id) { 100 }

  describe '#add_task' do
    it do
      list.add_task(task_id)
      expect(list).to eq([TodaysTask.new(task_id: task_id, user_id: user_id)])
    end
  end
end
