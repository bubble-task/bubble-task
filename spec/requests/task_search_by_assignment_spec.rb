require 'rails_helper'

describe 'GET /search' do
  before do
    request_sign_in_as(assignee_a)
    expected_tasks
    unexpected_tasks
  end

  let(:task_author) { create_user_from_oauth_credential(generate_auth_hash(email: 'task@gaiax.com')) }
  let(:assignee_a) { create_user_from_oauth_credential }
  let(:assignee_b) { create_user_from_oauth_credential(generate_auth_hash(email: 'other@gaiax.com')) }
  let(:uncompleted_task) do
    create_task(author_id: task_author.id, title: '未完了タスク', tags: %w(tag), assignees: [assignee_a])
  end

  let(:expected_task_ids) { expected_tasks.map(&:id) }

  context '自分がサインアップしたタスクに限定しない' do
    let(:expected_tasks) do
      [
        create_task(
          author_id: task_author.id, title: 'a', tags: %w(tag),
          completed_at: 2.days.ago, assignees: [assignee_a]
        ),
        create_task(
          author_id: task_author.id, title: 'b', tags: %w(tag),
          completed_at: 1.days.ago, assignees: [assignee_b]
        ),
      ]
    end

    let(:unexpected_tasks) { [uncompleted_task] }

    it do
      get search_path(c: { is_signed_up_only: nil, completion_state: 'completed' })
      expect(assigned_task_ids).to match_array(expected_task_ids)
    end
  end

  context '自分がサインアップしたタスクに限定する' do
    let(:expected_tasks) do
      [
        create_personal_task(
          user_id: assignee_a.id, title: 'a', completed_at: 2.days.ago
        ),
        create_task(
          author_id: task_author.id, title: 'b', tags: %w(tag),
          completed_at: 1.days.ago, assignees: [assignee_a]
        ),
      ]
    end

    let(:unexpected_tasks) do
      [
        uncompleted_task,
        create_task(author_id: task_author.id, title: 'b', tags: %w(tag), completed_at: :now, assignees: [assignee_b]),
      ]
    end

    it do
      get search_path(c: { is_signed_up_only: '1', completion_state: 'completed' })
      expect(assigned_task_ids).to match_array(expected_task_ids)
    end
  end
end
