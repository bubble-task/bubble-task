require 'rails_helper'

describe 'タスクの作成画面から戻る' do
  before do
    sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task) { create_task(author_id: user.id, title: 'title', tags: [tag], assignees: [user]) }
  let(:tag) { 'TAG' }

  let(:task_creation_link) { first('.task-creation-link') }
  let(:back_link) { first('.back-link') }

  context 'ホーム画面から遷移した場合' do
    it do
      visit root_path
      task_creation_link.click
      back_link.click
      expect(current_path).to eq(root_path)
    end
  end

  context 'タグのタスク一覧から遷移した場合' do
    it do
      visit tasks_path(tag: tag)
      task_creation_link.click
      back_link.click
      expect(current_url).to include(tasks_path(tag: tag))
    end
  end
end
