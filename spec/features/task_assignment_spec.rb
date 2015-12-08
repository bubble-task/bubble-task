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
      within("#task_#{task.id}") do
        find('a', text: '自分をアサインする', visible: false).trigger('click')
      end
      within("#task_#{task.id}") do
        assignee_avatar = first(".assignee_#{user.id}")
        expect(assignee_avatar).to_not be_nil
      end
    end
  end
end
