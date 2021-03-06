require 'rails_helper'

describe Task do
  let(:task) { Task.new(author_id: 1, title: 'Title') }

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
        task.remove_description
        expect(task.description).to be_nil
      end
    end
  end

  describe '完了状態にする' do
    it do
      task.to_personal_task(1)
      task.complete(1)
      expect(task).to be_completed
    end
  end

  describe 'デフォルトでは未完了の状態' do
    it { expect(task).to_not be_completed }
  end

  describe '削除する' do
    it do
      task.tagging_by(%w(タグ))
      task.write_description('タスクの説明')
      task.remove!
      expect(task).to be_removed
      expect(task.description).to be_nil
      expect(task.tags).to be_empty
    end
  end

  describe 'デフォルトでは削除されていない状態' do
    it { expect(task).to_not be_removed }
  end

  describe '完了を取り消す' do
    it do
      task.to_personal_task(1)
      task.complete(1)
      task.cancel_completion
      expect(task).to_not be_completed
    end
  end

  describe '期限を設定する' do
    it do
      deadline = Time.current
      task.set_deadline(deadline)
      expect(task.deadline).to eq(deadline)
    end
  end

  describe '期限を再設定する' do
    context '期限が設定されていない場合' do
      it do
        deadline = Time.current
        task.reset_deadline(deadline)
        expect(task.deadline).to eq(deadline)
      end
    end

    context '期限が設定されている場合' do
      it do
        deadline = Time.current
        task.set_deadline(deadline.advance(days: 1))
        task.reset_deadline(deadline)
        expect(task.deadline).to eq(deadline)
      end
    end
  end

  describe '期限を削除する' do
    context '期限が設定されている場合' do
      it do
        deadline = Time.current
        task.set_deadline(deadline)
        task.remove_deadline
        expect(task.deadline).to be_nil
      end
    end
  end

  describe '完了が可能か判断する' do
    context '公開タスク:自分がサインアップしていない場合' do
      it do
        task.assignments.build(user_id: 1)
        expect(task.can_complete?(2)).to be_falsey
      end
    end

    context '公開タスク:自分がサインアップしている場合' do
      it do
        task.assignments.build(user_id: 1)
        expect(task.can_complete?(1)).to be_truthy
      end
    end

    context '公開タスク:誰もサインアップしていない場合' do
      it do
        expect(task.can_complete?(1)).to be_falsey
      end
    end

    context '個人タスク' do
      before do
        task.to_personal_task(1)
      end

      context '自分の個人タスク' do
        it { expect(task.can_complete?(1)).to be_truthy }
      end

      context '他人の個人タスク' do
        it { expect(task.can_complete?(2)).to be_falsey }
      end
    end
  end
end
