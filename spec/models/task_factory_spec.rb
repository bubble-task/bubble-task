require 'rails_helper'

describe TaskFactory do
  describe 'タスクを作成する' do
    context 'タスクの説明がない場合' do
      it do
        task = TaskFactory.create(1, 'タスクのタイトル')
        expect(task.title).to eq('タスクのタイトル')
        expect(task.author_id).to eq(1)
      end
    end

    context 'タスクの説明がある場合' do
      it do
        task = TaskFactory.create(1, 'タスクのタイトル', 'タスクの説明')
        expect(task.title).to eq('タスクのタイトル')
        expect(task.description).to eq('タスクの説明')
        expect(task.author_id).to eq(1)
      end
    end

    context 'タグが付加されている場合' do
      it do
        task = TaskFactory.create(1, 'タスクのタイトル', 'タスクの説明', %w(タグ1 タグ2))
        expect(task.tags).to eq(%w(タグ1 タグ2))
        expect(task.title).to eq('タスクのタイトル')
        expect(task.author_id).to eq(1)
      end
    end
  end
end