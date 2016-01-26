require 'rails_helper'

describe 'GET /achievements' do
  before do
    request_sign_in_as(assignee_a)
    expected_tasks
    unexpected_tasks
  end

  let(:assignee_a) { create_user_from_oauth_credential }
  let(:assignee_b) { create_user_from_oauth_credential(generate_auth_hash(email: 'other@user.com')) }

  context '完了日時とタグを指定する場合' do
    let(:expected_tasks) do
      [
        create_task(author_id: assignee_a.id, title: 'タスク1', tags: %w(タグA タグB), completed_at: '2016-01-01', assignees: [assignee_a]),
        create_task(author_id: assignee_a.id, title: 'タスク2', tags: %w(タグA タグB タグC), completed_at: '2016-01-02', assignees: [assignee_b]),
      ]
    end

    let(:unexpected_tasks) do
      [
        create_task(author_id: assignee_a.id, title: 'タスク3', tags: %w(タグA タグB), completed_at: '2015-12-30', assignees: [assignee_a]),
        create_task(author_id: assignee_a.id, title: 'タスク4', tags: %w(タグA タグB), completed_at: '2016-01-03', assignees: [assignee_a]),
        create_task(author_id: assignee_a.id, title: 'タスク5', completed_at: '2016-01-01', assignees: [assignee_a]),
        create_task(author_id: assignee_a.id, title: 'タスク6', tags: %w(タグA タグC), completed_at: '2016-01-01', assignees: [assignee_b]),
        create_task(author_id: assignee_a.id, title: 'タスク7', tags: %w(タグA), completed_at: '2016-01-01', assignees: [assignee_b]),
        create_task(author_id: assignee_a.id, title: 'タスク8', tags: %w(タグC), completed_at: '2016-01-01', assignees: [assignee_b]),
      ]
    end

    it do
      get search_path(c: { from_date: '2015-12-31', to_date: '2016-01-02', tag_words: 'タグA タグB', is_signed_up_only: '0' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end
end
