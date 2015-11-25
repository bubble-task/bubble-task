require 'rails_helper'

describe 'タスクのタグからタグに紐づくタスクの一覧ページを表示する' do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
  end

  def create_task(*args)
    TaskFactory
      .create(*args)
      .tap(&:save)
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }

  let(:auth_hash) { generate_auth_hash }

  it do
    create_task(user.id, 'タスクのタイトル', nil, ['タグ1'])
    visit root_path
    click_link('タグ1')
    tag = first('.header .tag').text
    tasks = all('.task-summary .task-title').map(&:text)
    expect(tag).to eq('タグ1')
    expect(tasks).to eq(%w(タスクのタイトル))
  end
end
