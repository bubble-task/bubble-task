require 'rails_helper'

describe 'GET /search' do
  before do
    request_sign_in_as(user_a)
    expected_tasks
    unexpected_tasks
  end

  let(:user_a) { create_user_from_oauth_credential }
  let(:user_b) { create_user_from_oauth_credential(generate_auth_hash(email: 'other@user.com')) }

  context '期間を指定,自分がサインアップ=OFF,タグを複数指定,完了/未完了どちらも' do
    let(:expected_tasks) do
      [
        create_task(author_id: user_a.id, title: 'タスク1', tags: %w(タグA タグB), completed_at: '2016-01-01', assignees: [user_a]),
        create_task(author_id: user_a.id, title: 'タスク2', tags: %w(タグA タグB タグC), completed_at: '2016-01-02', assignees: [user_b]),
      ]
    end

    let(:unexpected_tasks) do
      [
        create_task(author_id: user_a.id, title: 'タスク3', tags: %w(タグA タグB), completed_at: '2015-12-30', assignees: [user_a]),
        create_task(author_id: user_a.id, title: 'タスク4', tags: %w(タグA タグB), completed_at: '2016-01-03', assignees: [user_a]),
        create_task(author_id: user_a.id, title: 'タスク5', completed_at: '2016-01-01', assignees: [user_a]),
        create_task(author_id: user_a.id, title: 'タスク6', tags: %w(タグA タグC), completed_at: '2016-01-01', assignees: [user_b]),
        create_task(author_id: user_a.id, title: 'タスク7', tags: %w(タグA), completed_at: '2016-01-01', assignees: [user_b]),
        create_task(author_id: user_a.id, title: 'タスク8', tags: %w(タグC), completed_at: '2016-01-01', assignees: [user_b]),
      ]
    end

    it do
      get search_path(c: { from_date: '2015-12-31', to_date: '2016-01-02', tag_words: 'タグA タグB', is_signed_up_only: '0', completion_state: 'any' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '期間を指定,自分がサインアップ=OFF,完了/未完了どちらも' do
    let(:expected_tasks) do
      [
        create_task(author_id: user_a.id, title: 'タスク1', tags: %w(タグA), completed_at: '2016-01-01', assignees: [user_a]),
        create_task(author_id: user_a.id, title: 'タスク2', tags: %w(タグA), completed_at: '2016-01-02', assignees: [user_b]),
      ]
    end

    let(:unexpected_tasks) do
      [
        create_task(author_id: user_a.id, title: 'タスク3', tags: %w(タグA), completed_at: '2015-12-30', assignees: [user_a]),
        create_task(author_id: user_a.id, title: 'タスク4', tags: %w(タグA), completed_at: '2016-01-03', assignees: [user_a]),
        create_task(author_id: user_a.id, title: 'タスク5', assignees: [user_a]),
      ]
    end

    it do
      get search_path(c: { from_date: '2015-12-31', to_date: '2016-01-02', is_signed_up_only: '0', completion_state: 'any' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end
end
