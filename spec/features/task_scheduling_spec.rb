require 'rails_helper'

describe 'タスクのスケジューリング' do
  before do
    sign_in_as(user_a)
    tasks
  end

  let(:user_a) { create_user_from_oauth_credential }
  let(:user_b) { create_user_from_oauth_credential(generate_auth_hash(email: 'user@b.com')) }
  let(:task_a) { create_task(author_id: user_a.id, title: 'A', tags: ['TAG'], assignees: [user_a, user_b]) }
  let(:task_b) { create_task(author_id: user_a.id, title: 'B', tags: ['TAG'], assignees: [user_a, user_b]) }

  let(:move_to_todays_tasks_css) { '.somedays-tasks .move-to-todays-tasks' }
  let(:move_to_somedays_tasks_css) { '.todays-tasks .move-to-somedays-tasks' }
  let(:wait_moving) { find('#toast-container') }
  let(:target_task_css_id_in_today) { first('.todays-tasks .task-summary')[:id] }
  let(:target_task_css_id_in_someday) { first('.somedays-tasks .task-summary')[:id] }
  let(:tasks_in_today) { all('.todays-tasks .task-summary') }
  let(:tasks_in_someday) { all('.somedays-tasks .task-summary') }

  describe '今日のタスクに追加' do
    context 'タスクが1つしかない場合' do
      let(:tasks) { [task_a] }

      it do
        visit root_path
        first(move_to_todays_tasks_css).click
        expect(target_task_css_id_in_today).to eq("task_#{task_a.id}")
        expect(tasks_in_someday).to be_empty
      end

      it do
        visit root_path
        first(move_to_todays_tasks_css).click
        first('.user-sign-out', visible: false).click
        sign_in_as(user_b)
        visit root_path
        expect(tasks_in_today).to be_empty
        expect(tasks_in_someday.size).to eq(1)
      end
    end

    context 'タスクが2つある場合' do
      let(:tasks) { [task_a, task_b] }

      it do
        visit root_path
        first(move_to_todays_tasks_css).click
        first(move_to_todays_tasks_css).click
        expect(tasks_in_today.size).to eq(2)
        expect(tasks_in_someday).to be_empty
      end
    end
  end

  describe '今日のタスクから削除' do
    context '今日のタスクが1つの場合' do
      let(:tasks) { [task_a] }

      before do
        TaskScheduling.new(task_a.id, TodaysTaskList.load(user_a.id)).run
      end

      it do
        visit root_path
        first(move_to_somedays_tasks_css).click
        expect(target_task_css_id_in_someday).to eq("task_#{task_a.id}")
        expect(tasks_in_today).to be_empty
      end
    end

    context '今日のタスクが2つある場合' do
      let(:tasks) { [task_a, task_b] }

      before do
        TaskScheduling.new(task_a.id, TodaysTaskList.load(user_a.id)).run
        TaskScheduling.new(task_b.id, TodaysTaskList.load(user_a.id)).run
      end

      it do
        visit root_path
        first(move_to_somedays_tasks_css).click
        first(move_to_somedays_tasks_css).click
        expect(tasks_in_today).to be_empty
        expect(tasks_in_someday.size).to eq(2)
      end
    end
  end

  context 'デフォルト' do
    let(:tasks) { [task_a] }

    it do
      visit root_path
      expect(tasks_in_today).to be_empty
      expect(tasks_in_someday.size).to eq(1)
    end
  end
end
