require 'rails_helper'

describe 'タスク検索結果から完了にする', js: true do
  before do
    sign_in_as(user_a)
    task
  end

  let(:user_a) { create_user_from_oauth_credential }

  let(:wait_completion) { find('#toast-container') }
  let(:completed_checkbox_id) { "#task_#{task.id}_completion_check" }
  let(:completed_checkbox) { find(completed_checkbox_id, visible: false) }
  let(:completed_checkbox_label_id) { "#task_#{task.id}_completion_mark" }

  let(:task) { create_task(author_id: user_a.id, title: '公開タスク1', tags: %w(Tag), assignees: [user_a]) }

  it do
    visit search_path
    select '完了/未完了どちらも', from: 'c[completion_state]'
    click_button(I18n.t('search.index.actions.search'))
    find(completed_checkbox_label_id, visible: false).click
    wait_completion
    expect(completed_checkbox).to be_checked
  end
end
