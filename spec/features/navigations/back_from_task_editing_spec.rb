require 'rails_helper'

describe 'タスクの編集画面から戻る' do
  before do
    sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task) { create_task(author_id: user.id, title: 'title', tags: [tag], assignees: [user]) }
  let(:tag) { 'TAG' }

  let(:task_editing_link) { first('.task-editing-link', visible: false) }
  let(:back_link) { first('.back-link') }

  let(:invoke_validation_error) { update_task_from_ui_without_visit(title: 'a' * 100) }

  context 'ホーム画面から遷移した場合' do
    before do
      visit root_path
      task_editing_link.click
    end

    it do
      back_link.click
      expect(current_path).to eq(root_path)
    end

    context 'エラーになった場合' do
      it do
        invoke_validation_error
        back_link.click
        expect(current_path).to eq(root_path)
      end
    end
  end

  context 'タグのタスク一覧から遷移した場合' do
    before do
      visit tasks_path(tag: tag)
      task_editing_link.click
    end

    it do
      back_link.click
      expect(current_url).to include(tasks_path(tag: tag))
    end

    context 'エラーになった場合' do
      it do
        invoke_validation_error
        back_link.click
        expect(current_url).to include(tasks_path(tag: tag))
      end
    end
  end

  context 'タスク詳細画面から遷移した場合' do
    before do
      visit task_path(task)
      task_editing_link.click
    end

    it do
      back_link.click
      expect(current_path).to eq(task_path(task))
    end

    context 'エラーになった場合' do
      it do
        invoke_validation_error
        back_link.click
        expect(current_path).to eq(task_path(task))
      end
    end
  end
end
