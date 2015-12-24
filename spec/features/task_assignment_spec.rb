require 'rails_helper'

describe 'タスクのアサイン', js: true do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
    task
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }
  let(:task) { create_task(author_id: user.id, title: 'タスクのタイトル', tags: [tag]) }
  let(:tag) { 'タグ' }
  let(:assign_link_css_path) { '.assign_myself' }
  let(:assignee_avatar) { find(".assignee_#{user.id}") }

  describe '自分のタスク一覧から操作する' do
    before { visit root_path }

    it do
      find(assign_link_css_path).trigger('click')
      expect(assignee_avatar).to_not be_nil
    end

    it do
      find(assign_link_css_path).trigger('click')
      visit root_path
      expect(assignee_avatar).to_not be_nil
    end

    it do
      find(assign_link_css_path).trigger('click')
      find(".assignee_#{user.id}")
      assign_link = first(assign_link_css_path)
      expect(assign_link).to be_nil
    end

    let(:other_user) { create_user_from_oauth_credential(generate_auth_hash(email: 'user2@emai.l')) }

    it do
      command = TaskAssignment.new(task: task, assignee: other_user)
      command.run

      find(assign_link_css_path).trigger('click')
      expect(assignee_avatar).to_not be_nil
    end
  end

  describe 'タスク詳細から操作する' do
    before { visit task_path(task) }

    it do
      find(assign_link_css_path).trigger('click')
      expect(assignee_avatar).to_not be_nil
    end
  end

  describe 'タグのタスク一覧から操作する' do
    before { visit tasks_path(tag: tag) }

    it do
      find(assign_link_css_path).trigger('click')
      expect(assignee_avatar).to_not be_nil
    end
  end
end
