require 'rails_helper'

describe 'タスクの検索' do
  before do
    sign_in_as(user)
  end

  let(:user) { create_user_from_oauth_credential }

  let(:completed_task) { create_task(author_id: user.id, title: '完了', completed_at: :now, assignees: [user]) }
  let(:uncompleted_task) { create_task(author_id: user.id, title: '未完了', assignees: [user]) }

  context '遷移しただけで条件を指定しない場合' do
    before do
      completed_task
      uncompleted_task
    end

    let(:title_on_page) { first('.task-title') }

    it do
      visit search_path
      expect(title_on_page).to be_nil
    end
  end
end
