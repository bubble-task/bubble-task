require 'rails_helper'

describe 'GET /search' do
  before do
    request_sign_in_as(user_b)
    expected_tasks
  end

  let(:user_a) { create_user_from_oauth_credential(generate_auth_hash(email: 'a@gaiax.com')) }
  let(:user_b) { create_user_from_oauth_credential(generate_auth_hash(email: 'b@gaiax.com')) }

  context '検索結果はタスクの作成日時の昇順' do
    let(:expected_tasks) { [task2, task3, task1] }
    let(:expected_ordered_tasks) { [task2, task3, task1] }

    let(:task1) { create_task(author_id: user_a.id, title: '1', tags: %w(tag), completed_at: '2015-12-01 00:00:00', assignees: [user_a]) }
    let(:task2) { create_task(author_id: user_a.id, title: '2', tags: %w(tag), completed_at: '2015-12-01 00:00:01', assignees: [user_a]) }
    let(:task3) { create_task(author_id: user_a.id, title: '3', tags: %w(tag), completed_at: '2015-12-05', assignees: [user_a]) }

    it do
      get search_path(c: { from_date: nil, to_date: nil, is_signed_up_only: '0' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_ordered_tasks)
    end
  end
end
