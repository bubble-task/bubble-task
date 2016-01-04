require 'rails_helper'

describe 'タスクの編集画面から戻る' do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
    task
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }
  let(:task) { create_task(author_id: user.id, title: 'title', tags: [tag], assignees: [user]) }
  let(:tag) { 'TAG' }

  let(:task_editing_link) { first('.task-editing-link', visible: false) }
  let(:back_link) { first('.back-link') }

  context 'ホーム画面から遷移した場合' do
    it do
      visit root_path
      task_editing_link.click
      back_link.click
      expect(current_path).to eq(root_path)
    end
  end

  context 'タグのタスク一覧から遷移した場合' do
    it do
      visit tasks_path(tag: tag)
      task_editing_link.click
      back_link.click
      expect(current_url).to include(tasks_path(tag: tag))
    end
  end

  context 'タスク詳細画面から遷移した場合' do
    it do
      visit task_path(task)
      task_editing_link.click
      back_link.click
      expect(current_path).to eq(task_path(task))
    end
  end
end
