require 'rails_helper'

describe 'タスクの完了のキャンセル' do
  before do
    sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task) { create_task(author_id: user.id, title: title, completed_at: :now, assignees: [user]) }
  let(:title) { 'タスクのタイトル' }

  it do
    visit search_path(c: { completion_state: 'completed' })
    first('.cancel-completion').click
    achievement = first('.achievement')
    expect(achievement).to be_nil
  end
end
