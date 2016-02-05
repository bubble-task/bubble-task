require 'rails_helper'

describe 'GET /search' do
  before do
    request_sign_in_as(user_b)
    expected_tasks
  end

  let(:user_a) { create_user_from_oauth_credential(generate_auth_hash(email: 'a@u.ser')) }
  let(:user_b) { create_user_from_oauth_credential(generate_auth_hash(email: 'b@u.ser')) }

  context '検索結果はタスクの作成日時の昇順' do
    let(:expected_tasks) { [task2, task3, task1] }
    let(:expected_ordered_tasks) { [task2, task3, task1] }

    let(:task1) { create_task(author_id: user_a.id, title: '1', completed_at: '2015-12-01 00:00:00') }
    let(:task2) { create_task(author_id: user_a.id, title: '2', completed_at: '2015-12-01 00:00:01') }
    let(:task3) { create_task(author_id: user_a.id, title: '3', completed_at: '2015-12-05') }

    it do
      get search_path(c: { from_date: nil, to_date: nil, is_signed_up_only: '0' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_ordered_tasks)
    end
  end
end
