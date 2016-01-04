require 'rails_helper'

describe '完了したタスクの一覧' do
  before do
    sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }

  let(:task) { create_task(author_id: user.id, title: 'タスクのタイトル', tags: %w(タグ)) }
  let(:title_on_page) { first('.task-title') }
  let(:title_text_on_page) { title_on_page.text }

  context '完了したタスクがある場合' do
    before do
      TaskCompletion.new(task_id: task.id).run
      visit achievements_path
    end

    it do
      expect(title_text_on_page).to eq(task.title)
    end

    it '完了日付が表示されていること' do
      completed_on = first('.task-completed-on').text
      expect(completed_on).to eq(I18n.l(task.completed_task.completed_at.to_date, format: :default))
    end
  end

  context '完了したタスクがない場合' do
    it do
      visit achievements_path
      expect(title_on_page).to be_nil
    end
  end
end
