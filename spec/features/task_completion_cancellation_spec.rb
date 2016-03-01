require 'rails_helper'

describe 'タスクの完了のキャンセル', js: true do
  before do
    sign_in_as(user)
    task
  end

  let(:user) { create_user_from_oauth_credential }
  let(:task) { create_task(author_id: user.id, title: title, completed_at: :now, assignees: [user]) }
  let(:title) { 'タスクのタイトル' }

  let(:wait_cancellation_completion) { find('#toast-container') }
  let(:completed_checkbox_id) { "#task_#{task.id}_completion_check" }
  let(:completed_checkbox) { find(completed_checkbox_id, visible: false) }
  let(:completed_checkbox_label_id) { "#task_#{task.id}_completion_mark" }

  it do
    visit search_path(c: { completion_state: 'any' })
    find(completed_checkbox_label_id, visible: false).click
    wait_cancellation_completion
    expect(completed_checkbox).to_not be_checked

    #first('.cancel-completion').click
    #achievement = first('.achievement')
    #expect(achievement).to be_nil
  end
end
