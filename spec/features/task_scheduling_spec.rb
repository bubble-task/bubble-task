require 'rails_helper'

describe 'タスクのスケジューリング' do
  before do
    sign_in_as(user)
    tasks
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task_a) { create_task(author_id: user.id, title: 'A', tags: ['TAG'], assignees: [user]) }
  let(:task_b) { create_task(author_id: user.id, title: 'B', tags: ['TAG'], assignees: [user]) }

  context 'タスクが1つしかない場合' do
    let(:tasks) { [task_a] }

    it do
      visit root_path
      first('.somedays-tasks .move-to-todays-tasks').click

      target_task_css_id_in_today = first('.todays-tasks .task-summary')[:id]
      expect(target_task_css_id_in_today).to eq("task_#{task_a.id}")

      target_task_in_someday = first('.somedays-tasks .task-summary')
      expect(target_task_in_someday).to be_nil
    end
  end

  context 'タスクが2つある場合' do
    let(:tasks) { [task_a, task_b] }

    it do
      visit root_path
      first('.somedays-tasks .move-to-todays-tasks').click
      first('.somedays-tasks .move-to-todays-tasks').click

      tasks_in_today = all('.todays-tasks .task-summary').size
      expect(tasks_in_today).to eq(2)

      tasks_in_someday = all('.somedays-tasks .task-summary').size
      expect(tasks_in_someday).to eq(0)
    end
  end

  context 'デフォルト' do
    let(:tasks) { [task_a] }

    it do
      visit root_path

      tasks_in_today = all('.todays-tasks .task-summary').size
      expect(tasks_in_today).to eq(0)

      tasks_in_someday = all('.somedays-tasks .task-summary').size
      expect(tasks_in_someday).to eq(1)
    end
  end
end
