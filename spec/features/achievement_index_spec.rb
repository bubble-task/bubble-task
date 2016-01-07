require 'rails_helper'

describe '完了したタスクの一覧' do
  before do
    sign_in_as(assignee)
    task
  end

  let(:task_author) { create_user_from_oauth_credential }
  let(:assignee) { create_user_from_oauth_credential(generate_auth_hash(email: 'as@sig.nee')) }

  let(:task) { create_task(author_id: task_author.id, title: 'タスクのタイトル', tags: %w(タグ)) }

  let(:title_on_page) { first('.task-title') }
  let(:title_text_on_page) { title_on_page.text }

  context 'サインアップしたタスクが完了している場合' do
    before do
      TaskAssignment.new(task: task, assignee: assignee).run
      TaskCompletion.new(task_id: task.id).run
      visit achievements_path
    end

    it do
      expect(title_text_on_page).to eq(task.title)
    end

    it '完了日付が表示されていること' do
      completed_on = first('.task-completed-on').text
      expected_completed_on = I18n.l(task.reload.completed_task.completed_at.to_date, format: :default)
      expect(completed_on).to eq(expected_completed_on)
    end
  end

  context 'サインアップしたタスクが完了していない場合' do
    before do
      TaskAssignment.new(task: task, assignee: assignee).run
      visit achievements_path
    end

    it do
      expect(title_on_page).to be_nil
    end
  end

  context 'サインアップしていないタスクが完了している場合' do
    let(:task) do
      create_task(
        author_id: assignee.id,
        assignees: [task_author],
        completed_at: :now,
        tags: %w(タグ),
        title: 'タスクのタイトル',
      )
    end

    it do
      visit achievements_path
      expect(title_on_page).to be_nil
    end
  end

  context 'サインアップしていないタスクが完了していない場合' do
    let(:task) do
      create_task(
        author_id: assignee.id,
        assignees: [task_author],
        tags: %w(タグ),
        title: 'タスクのタイトル',
      )
    end

    it do
      visit achievements_path
      expect(title_on_page).to be_nil
    end
  end
end
