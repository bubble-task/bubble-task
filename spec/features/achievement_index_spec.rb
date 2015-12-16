require 'rails_helper'

describe '完了したタスクの一覧' do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
    task
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }

  let(:task) { create_task(author_id: user.id, title: 'タスクのタイトル', tags: [tag]) }
  let(:tag) { 'タグ' }

  it do
    TaskCompletion.new(task_id: task.id).run
    visit achievements_path
    title = first('.task-title').text
    expect(title).to eq(task.title)
  end

  it do
    visit achievements_path
    title = first('.task-title')
    expect(title).to be_nil
  end
end
