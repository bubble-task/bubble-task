require 'rails_helper'

describe 'GET /achievements' do
  before do
    request_sign_in_as(assignee_a)
    expected_tasks
    unexpected_tasks
  end

  let(:task_author) { create_user_from_oauth_credential(generate_auth_hash(email: 'task@auth.or')) }
  let(:assignee_a) { create_user_from_oauth_credential }
  let(:assignee_b) { create_user_from_oauth_credential(generate_auth_hash(email: 'other@user.com')) }
  let(:uncompleted_task) { create_task(author_id: task_author.id, title: '未完了タスク', assignees: [assignee_a]) }

  context 'サインアップしたユーザを指定しない' do
    let(:expected_tasks) do
      [
        create_task(author_id: task_author.id, title: 'a', completed_at: :now, assignees: [assignee_a]),
        create_task(author_id: task_author.id, title: 'b', completed_at: :now, assignees: [assignee_b]),
      ]
    end

    let(:unexpected_tasks) { [uncompleted_task] }

    it do
      get achievements_path(c: { is_signed_up_only: nil })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end
end
