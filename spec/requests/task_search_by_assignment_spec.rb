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
  let(:uncompleted_task) { create_task(author_id: task_author.id, title: '未完了タスク', assignees: [assignee_a]) }

  context '自分がサインアップしたタスクに限定しない' do
    let(:expected_tasks) do
      [
        create_task(author_id: task_author.id, title: 'a', completed_at: :now, assignees: [assignee_a]),
        create_task(author_id: task_author.id, title: 'b', completed_at: :now, assignees: [assignee_b]),
      ]
    end

    let(:unexpected_tasks) { [uncompleted_task] }

    it do
      get search_path(c: { is_signed_up_only: nil, completion_state: 'completed' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '自分がサインアップしたタスクに限定する' do
    let(:expected_tasks) do
      [create_personal_task(user_id: assignee_a.id, title: 'a', completed_at: :now)]
    end

    let(:unexpected_tasks) do
      [
        uncompleted_task,
        create_task(author_id: task_author.id, title: 'b', completed_at: :now, assignees: [assignee_b]),
      ]
    end

    it do
      get search_path(c: { is_signed_up_only: '1', completion_state: 'completed' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end
end
