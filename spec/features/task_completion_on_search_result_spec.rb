require 'rails_helper'

describe 'タスク検索結果から完了にする', js: true do
  before do
    sign_in_as(user_a)
    task
  end

  let(:user_a) { create_user_from_oauth_credential }
  let(:user_b) { create_user_from_oauth_credential }

  context 'サインアップしている場合' do
    let(:task) { create_task(author_id: user_a.id, title: '公開タスク', tags: %w(Tag), assignees: [user_a]) }

    context '完了/未完了を問わない場合' do
      it do
        visit search_path(c: { completion_state: 'any', is_signed_up_only: '1' })
        complete_task(task.id)
        wait_completion
        expect(completion_checkbox(task.id)).to be_checked
      end
    end

    context '未完了タスクのみの場合' do
      it do
        visit search_path(c: { completion_state: 'uncompleted', is_signed_up_only: '1' })
        complete_task(task.id)
        wait_completion
        expect(first(completion_checkbox_id(task.id))).to be_nil
        visit search_path(c: { completion_state: 'completed', is_signed_up_only: '1' })
        expect(completion_checkbox(task.id)).to_not be_nil
      end
    end
  end

  context 'サインアップしていない場合', js: false do
    let(:task) { create_task(author_id: user_a.id, title: '公開タスク', tags: %w(Tag), assignees: [user_b]) }

    context '完了/未完了を問わない場合' do
      it do
        visit search_path(c: { completion_state: 'any', is_signed_up_only: '0' })
        expect(completion_checkbox(task.id)).to be_nil
      end
    end

    context '未完了タスクのみの場合' do
      it do
        visit search_path(c: { completion_state: 'uncompleted', is_signed_up_only: '0' })
        expect(completion_checkbox(task.id)).to be_nil
      end
    end
  end
end
