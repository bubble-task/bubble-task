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

  describe '自分のタスク一覧から操作する' do
    it do
      visit root_path
      task_summary_id = "task_#{task.id}"
      find('a', text: '自分をアサインする', visible: false).trigger('click')
      assignee_avatar = find(".assignee_#{user.id}")
      expect(assignee_avatar).to_not be_nil
    end

    it do
      visit root_path
      task_summary_id = "task_#{task.id}"
      find('a', text: '自分をアサインする', visible: false).trigger('click')

      visit root_path
      assignee_avatar = find(".assignee_#{user.id}")
      expect(assignee_avatar).to_not be_nil
    end

    it do
      visit root_path
      task_summary_id = "task_#{task.id}"
      find('a', text: '自分をアサインする', visible: false).trigger('click')
      find(".assignee_#{user.id}")
      assign_link = first('a', text: '自分をアサインする', visible: false)
      expect(assign_link).to be_nil
    end

    it do
      user2 = create_user_from_oauth_credential(generate_auth_hash(email: 'user2@emai.l'))
      task.assign(user2.id)
      task.save
      visit root_path
      task_summary_id = "task_#{task.id}"
      find('a', text: '自分をアサインする', visible: false).trigger('click')
      assignee_avatar = find(".assignee_#{user.id}")
      expect(assignee_avatar).to_not be_nil
    end
  end
end
