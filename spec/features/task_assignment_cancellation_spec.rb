require 'rails_helper'

describe 'タスクのアサインを解除', js: true do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
    task
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }
  let(:task) { create_task(author_id: user.id, title: 'タスクのタイトル', tags: [tag]) }
  let(:tag) { 'タグ' }

  let(:wait_cancellation) { find('#toast-container') }

  it do
    assignment = TaskAssignment.new(task: task, assignee: user)
    assignment.run

    visit task_path(task.id)
    find('.cancel_assignment_myself').click

    wait_cancellation
    assigned_avatar = first(".assignee_#{user.id}")
    expect(assigned_avatar).to be_nil
  end
end
