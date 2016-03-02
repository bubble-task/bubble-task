require 'rails_helper'

describe 'タスクの完了のキャンセル', js: true do
  before do
    sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task) { create_task(author_id: user.id, title: title, completed_at: :now, assignees: [user]) }
  let(:title) { 'タスクのタイトル' }

  context '完了/未完了を問わない場合' do
    it do
      visit search_path(c: { completion_state: 'any' })
      uncomplete_task(task.id)
      wait_cancellation_completion
      expect(completion_checkbox(task.id)).to_not be_checked
    end
  end

  context '完了タスクのみの場合' do
    it do
      visit search_path(c: { completion_state: 'completed' })
      uncomplete_task(task.id)
      wait_cancellation_completion
      expect(completion_checkbox(task.id)).to be_nil
      visit search_path(c: { completion_state: 'uncompleted' })
      expect(completion_checkbox(task.id)).to_not be_nil
    end
  end
end
