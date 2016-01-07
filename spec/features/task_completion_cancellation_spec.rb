require 'rails_helper'

describe 'タスクの完了のキャンセル', js: true do
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
    find(completed_checkbox_label_id, visible: false).click
    wait_completion
    expect(completed_checkbox).to_not be_checked

    visit task_path(task)
    expect(completed_checkbox).to_not be_checked
  end

  it do
    visit task_path(task)
    find(completed_checkbox_label_id, visible: false).click
    wait_completion

    visit root_path
    expect(title_on_page).to eq(title)
  end
end
