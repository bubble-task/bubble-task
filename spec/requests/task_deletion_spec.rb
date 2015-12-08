require 'rails_helper'

describe 'DELETE /tasks/:id' do
  before do
    user
    request_oauth_sign_in(auth_hash: auth_hash)
    task
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }

  let(:task) { create_task(author_id: user.id, title: title, description: '説明') }
  let(:title) { 'タスクのタイトル' }

  it do
    delete task_path(task)
    follow_redirect!
    expect(response.body).to_not include(title)
  end
end
