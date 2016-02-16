require 'rails_helper'

describe TaskFactory do
  describe 'タスクを作成する' do
    context 'タスクの説明がない場合' do
      it do
        task = TaskFactory.create(1, 'タスクのタイトル')
        expect(task.title).to eq('タスクのタイトル')
        expect(task.author_id).to eq(1)
        expect(task.description).to be_nil
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

    context '期限が設定されている場合' do
      it do
        task = TaskFactory.create(1, 'タスクのタイトル', nil, nil, Time.zone.parse('2016/02/03 10:00'))
        expect(task.deadline).to eq(Time.zone.parse('2016/02/03 10:00'))
      end
    end

    context '個人タスクを作成する場合' do
      it do
        task = TaskFactory.create(1, 'タスクのタイトル', 'タスクの説明')
        expect(task.author_id).to eq(1)
        expect(task.personal?).to be_truthy
      end
    end

    context '通常のタスクを作成する場合' do
      it do
        task = TaskFactory.create(1, 'タスクのタイトル', 'タスクの説明', %w(タグ1))
        expect(task.author_id).to eq(1)
        expect(task.personal?).to be_falsey
      end
    end
  end
end
