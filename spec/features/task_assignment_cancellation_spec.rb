require 'rails_helper'

describe 'タスクのアサインを解除' do
  before do
    sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task) { create_task(author_id: user.id, title: 'タスクのタイトル', tags: [tag]) }
  let(:tag) { 'タグ' }

  it do
    TaskAssignment.new(task: task, assignee: user).run

    visit task_path(task.id)
    find('.cancel_assignment_myself').click

    assigned_avatar = first(".assignee_#{user.id}")
    expect(assigned_avatar).to be_nil
    cancel_assingment_link = first('.cancel_assignment_myself')
    expect(cancel_assingment_link).to be_nil
  end

  it do
    TaskAssignment.new(task: task, assignee: user).run

    visit root_path
    cancel_assingment_link = first('.cancel_assignment_myself')
    expect(cancel_assingment_link).to be_nil
  end
end
