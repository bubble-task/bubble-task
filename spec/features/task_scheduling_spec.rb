require 'rails_helper'

describe 'タスクのスケジューリング' do
  before do
    sign_in_as(user)
    task_a
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task_a) { create_task(author_id: user.id, title: 'A', tags: ['TAG'], assignees: [user]) }

  it do
    visit root_path
    first('.somedays-tasks .move-to-todays-tasks').click

    target_task_css_id_in_today = first('.todays-tasks .task-summary')[:id]
    expect(target_task_css_id_in_today).to eq("task_#{task_a.id}")

    target_task_in_someday = first('.somedays-tasks .task-summary')
    expect(target_task_in_someday).to be_nil
  end
end
