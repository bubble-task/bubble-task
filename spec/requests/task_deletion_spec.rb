require 'rails_helper'

describe 'DELETE /tasks/:id' do
  before do
    request_sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }

  let(:task) { create_task(author_id: user.id, title: title, tags: [tag], description: '説明') }
  let(:title) { 'タスクのタイトル' }
  let(:tag) { 'タグ123' }

  it do
    delete task_path(task)
    follow_redirect!
    expect(response.body).to_not include(title)
  end

  it do
    delete task_path(task)
    get tags_path
    expect(response.body).to_not include(tag)
  end
end
