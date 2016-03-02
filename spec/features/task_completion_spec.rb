require 'rails_helper'

describe 'タスクの完了', js: true do
  before do
    sign_in_as(user_a)
    task
  end

  let(:user_a) { create_user_from_oauth_credential }
  let(:user_b) { create_user_from_oauth_credential }

  let(:task) { create_task(author_id: user_a.id, title: title, tags: [tag], assignees: [user_a]) }
  let(:title) { 'タスクのタイトル' }
  let(:tag) { 'タグ' }

  let(:completed_checkbox_id) { "#task_#{task.id}_completion_check" }
  let(:completed_checkbox) { find(completed_checkbox_id, visible: false) }
  let(:completed_checkbox_label_id) { "#task_#{task.id}_completion_mark" }

  let(:title_link) { first('.task-title') }

  describe 'タスクの作成直後' do
    it do
      visit root_path
      expect(completed_checkbox).to_not be_checked
    end
  end

  shared_examples_for 'チェックボックスが表示されていないこと' do
    it 'チェックボックスが表示されていないこと' do
      completion_checkbox = first(completed_checkbox_label_id)
      expect(completion_checkbox).to be_nil
    end
  end

  shared_examples_for 'タスクが完了状態になっていること' do
    it 'タスクが非表示になっていること' do
      find(completed_checkbox_label_id, visible: false).click
      wait_completion
      expect(title_link).to be_nil
    end

    it '一覧画面に再度アクセスするとタスクが非表示になっていること' do
      find(completed_checkbox_label_id, visible: false).click
      visit root_path
      expect(title_link).to be_nil
    end
  end

  shared_examples_for '完了にチェックが入っていること' do
    it do
      find(completed_checkbox_label_id, visible: false).click
      wait_completion
      expect(completed_checkbox).to be_checked
    end
  end

  describe '公開タスク:自分がサインアップしていないタスクを完了にする' do
    let(:task) { create_task(author_id: user_a.id, title: title, tags: [tag], assignees: [user_b]) }

    context 'タグのタスク一覧画面で操作する場合' do
      before { visit tasks_path(tag: tag) }
      it_behaves_like 'チェックボックスが表示されていないこと'
    end

    context 'タスク詳細画面で操作する場合' do
      before { visit task_path(task.id) }
      it_behaves_like 'チェックボックスが表示されていないこと'
    end
  end

  describe '公開タスク:誰もサインアップしていないタスクを完了にする' do
    let(:task) { create_task(author_id: user_a.id, title: title, tags: [tag]) }

    context 'タグのタスク一覧画面で操作する場合' do
      before { visit tasks_path(tag: tag) }
      it_behaves_like 'チェックボックスが表示されていないこと'
    end
  end

  describe '個人タスク:自分がサインアップしていないタスクを完了にする' do
    let(:task) { create_task(author_id: user_a.id, title: title) }

    context 'ホーム画面で操作する場合' do
      before { visit root_path }
      it_behaves_like 'タスクが完了状態になっていること'
    end

    context 'タスク詳細画面で操作する場合' do
      before { visit task_path(task.id) }
      it_behaves_like '完了にチェックが入っていること'
    end
  end

  context '個人タスク:自分がサインアップ済みタスクを完了にする' do
    let(:task) { create_task(author_id: user_a.id, title: title, assignees: [user_a]) }

    context 'ホーム画面で操作する場合' do
      before { visit root_path }
      it_behaves_like 'タスクが完了状態になっていること'
    end

    context 'タスク詳細画面で操作する場合' do
      before { visit task_path(task.id) }
      it_behaves_like '完了にチェックが入っていること'
    end
  end

  describe '公開タスク:自分がサインアップ済みのタスクを完了にする' do
    context 'ホーム画面で操作する場合' do
      before { visit root_path }
      it_behaves_like 'タスクが完了状態になっていること'
    end

    context 'タグのタスク一覧画面で操作する場合' do
      before { visit tasks_path(tag: tag) }
      it_behaves_like 'タスクが完了状態になっていること'
    end

    context 'タスク詳細画面で操作する場合' do
      before { visit task_path(task.id) }
      it_behaves_like '完了にチェックが入っていること'
    end
  end
end
