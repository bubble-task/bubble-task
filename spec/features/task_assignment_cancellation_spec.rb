require 'rails_helper'

describe 'タスクへのサインアップを取り消し' do
  before do
    sign_in_as(user)
    task
    TaskAssignment.new(task: task, assignee: user).run
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task) { create_task(author_id: user.id, title: 'タスクのタイトル', tags: [tag]) }
  let(:tag) { 'タグ' }

  let(:cancel_sign_up_link) { first('.cancel_sign_up') }
  let(:assignee_avatar) { first(".assignee_#{user.id}") }

  it do
    visit task_path(task.id)
    find('.cancel_sign_up').click
    expect(assignee_avatar).to be_nil
    expect(cancel_sign_up_link).to be_nil
  end

  it do
    visit root_path
    expect(cancel_sign_up_link).to be_nil
  end
end
