require 'rails_helper'

describe 'タスクの完了', js: true do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
    task
  end

  let(:task) { create_task(user.id, 'タスクのタイトル', nil, ['タグ']) }
  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }
  let(:completed_checkbox_id) { "#task_#{task.id}_completion_check" }
  let(:completed_checkbox) { find(completed_checkbox_id, visible: false) }
  let(:completed_checkbox_label_id) { "#task_#{task.id}_completion" }

  describe 'タスクを完了にする' do
    before do
      visit root_path
    end

    it do
      find(completed_checkbox_label_id, visible: false).click
      visit root_path
      expect(completed_checkbox).to be_checked
    end

    it { expect(completed_checkbox).to_not be_checked }
  end

  describe '完了後のページ' do
    it do
      visit root_path
      find(completed_checkbox_label_id, visible: false).click
      expect(page.current_path).to eq(root_path)
    end

    it do
      visit tasks_path(tag: 'タグ')
      find(completed_checkbox_label_id, visible: false).click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq(tasks_path(tag: 'タグ'))
    end
  end
end
