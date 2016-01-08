require 'rails_helper'

describe 'タスクの完了のキャンセル' do
  before do
    sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task) { create_task(author_id: user.id, title: title, completed_at: :now, assignees: [user]) }
  let(:title) { 'タスクのタイトル' }

  let(:completed_checkbox_id) { "#task_#{task.id}_completion_check" }
  let(:completed_checkbox) { find(completed_checkbox_id, visible: false) }
  let(:completed_checkbox_label_id) { "#task_#{task.id}_completion_mark" }
  let(:wait_completion) { find('#toast-container') }
  let(:title_on_page) { first('.task-title').text }

  it do
    visit task_path(task)
    first('.cancel-completion').click
    expect(completed_checkbox).to_not be_checked
  end
end
