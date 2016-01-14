require 'rails_helper'

describe 'タスクのアサイン', js: true do
  before do
    sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task) { create_task(author_id: user.id, title: 'タスクのタイトル', tags: [tag]) }
  let(:tag) { 'タグ' }
  let(:sign_up_link_css_path) { '.sign_up' }
  let(:assignee_avatar) { find(".assignee_#{user.id}") }

  describe 'タグのタスク一覧から操作する' do
    before { visit tasks_path(tag: tag) }

    it do
      find(sign_up_link_css_path).trigger('click')
      expect(assignee_avatar).to_not be_nil
    end

    it do
      find(sign_up_link_css_path).trigger('click')
      visit root_path
      expect(assignee_avatar).to_not be_nil
    end

    it do
      find(sign_up_link_css_path).trigger('click')
      find(".assignee_#{user.id}")
      assign_link = first(sign_up_link_css_path)
      expect(assign_link).to be_nil
    end

    let(:other_user) { create_user_from_oauth_credential(generate_auth_hash(email: 'user2@emai.l')) }

    it do
      TaskAssignment.new(task: task, assignee: other_user).run

      find(sign_up_link_css_path).trigger('click')
      expect(assignee_avatar).to_not be_nil
    end
  end

  describe 'タスク詳細から操作する' do
    before { visit task_path(task) }

    it do
      find(sign_up_link_css_path).trigger('click')
      expect(assignee_avatar).to_not be_nil
    end
  end
end
