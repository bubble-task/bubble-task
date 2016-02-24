require 'rails_helper'

describe 'タスクへのサインアップ', js: true do
  before do
    sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task) { create_task(author_id: user.id, title: 'タスクのタイトル', tags: [tag]) }
  let(:tag) { 'タグ' }
  let(:sign_up_link_css_path) { '.sign_up' }
  let(:assignee_avatar) { find(".assignee_#{user.id}") }
  let(:completed_checkbox_label_id) { "#task_#{task.id}_completion_mark" }

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
      sign_up_link = first(sign_up_link_css_path)
      expect(sign_up_link).to be_nil
    end

    it do
      find(sign_up_link_css_path).trigger('click')
      completion_checkbox = find(completed_checkbox_label_id)
      expect(completion_checkbox).to_not be_nil
    end

    let(:other_user) { create_user_from_oauth_credential(generate_auth_hash(email: 'user2@gaiax.com')) }

    it do
      TaskAssignment.new(task_id: task.id, assignee_id: other_user.id).run

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

    it do
      find(sign_up_link_css_path).trigger('click')
      completion_checkbox = find(completed_checkbox_label_id)
      expect(completion_checkbox).to_not be_nil
    end
  end
end
