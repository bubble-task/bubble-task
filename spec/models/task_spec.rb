require 'rails_helper'

describe Task do
  let(:task) { Task.new }

  describe '説明を追加する' do
    it do
      task.write_description('タスクの説明')
      expect(task.description).to eq('タスクの説明')
    end
  end

  describe 'タイトルを編集する' do
    it do
      task = Task.new(title: '古いタイトル')
      task.retitle('新しいタイトル')
      expect(task.title).to eq('新しいタイトル')
    end
  end

  describe '説明を編集する' do
    context 'タスクに説明が存在する場合' do
      it do
        task.write_description('古いタスクの説明')
        task.rewrite_description('新しいタスクの説明')
        expect(task.description).to eq('新しいタスクの説明')
      end
    end

    context 'タスクに説明が存在しない場合' do
      it do
        task.rewrite_description('新しいタスクの説明')
        expect(task.description).to eq('新しいタスクの説明')
      end
    end
  end

  describe '説明を削除する' do
    context 'タスクに説明が存在する場合' do
      it do
        task.write_description('古いタスクの説明')
        task.remove_description
        expect(task.description).to be_nil
      end
    end

    context 'タスクに説明が存在しない場合' do
      it do
        expect { task.remove_description }.to raise_error(Task::NotDescribed)
      end
    end
  end

  describe 'タグを削除する' do
    it do
      task.tagging(%w(タグ1 タグ2))
      task.remove_tags
      expect(task.tags).to be_empty
    end
  end
end
