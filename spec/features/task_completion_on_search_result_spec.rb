require 'rails_helper'

describe 'タスク検索結果から完了にする', js: true do
  before do
    sign_in_as(user_a)
    task
  end

  let(:user_a) { create_user_from_oauth_credential }
  let(:user_b) { create_user_from_oauth_credential }

  let(:wait_completion) { find('#toast-container') }
  let(:completed_checkbox_id) { "#task_#{task.id}_completion_check" }
  let(:completed_checkbox) { find(completed_checkbox_id, visible: false) }
  let(:completed_checkbox_label_id) { "#task_#{task.id}_completion_mark" }

  context 'サインアップしている場合' do
    let(:task) { create_task(author_id: user_a.id, title: '公開タスク', tags: %w(Tag), assignees: [user_a]) }

    context '完了/未完了を問わない場合' do
      it do
        visit search_path(c: { completion_state: 'any', is_signed_up_only: '1' })
        find(completed_checkbox_label_id, visible: false).click
        wait_completion
        expect(completed_checkbox).to be_checked
      end
    end

    context '未完了タスクのみの場合' do
      it do
        visit search_path(c: { completion_state: 'uncompleted', is_signed_up_only: '1' })
        find(completed_checkbox_label_id, visible: false).click
        wait_completion
        expect(first(completed_checkbox_id)).to be_nil
        visit search_path(c: { completion_state: 'completed', is_signed_up_only: '1' })
        expect(completed_checkbox).to_not be_nil
      end
    end
  end

  context 'サインアップしていない場合', js: false do
    let(:task) { create_task(author_id: user_a.id, title: '公開タスク', tags: %w(Tag), assignees: [user_b]) }

    it do
      visit search_path(c: { completion_state: 'any', is_signed_up_only: '0' })
      completion_checkbox = first(completed_checkbox_label_id)
      expect(completion_checkbox).to be_nil
    end
  end
end
