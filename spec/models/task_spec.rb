require 'rails_helper'

describe Task do
  describe '説明を追加する' do
    it do
      task = Task.new
      task.write_description('タスクの説明')
      expect(task.description).to eq('タスクの説明')
    end
  end
end
