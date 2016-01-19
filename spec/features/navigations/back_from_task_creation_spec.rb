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

  let(:invoke_validation_error) { create_task_from_ui_without_visit(title: nil) }

  context 'ホーム画面から遷移した場合' do
    before do
      visit root_path
      task_creation_link.click
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
      task_creation_link.click
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
end
