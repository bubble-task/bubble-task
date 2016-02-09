require 'rails_helper'

describe 'GET /search' do
  before do
    request_sign_in_as(user_b)
    expected_tasks
    unexpected_tasks
  end

  let(:user_a) { create_user_from_oauth_credential(generate_auth_hash(email: 'a@u.ser')) }
  let(:user_b) { create_user_from_oauth_credential(generate_auth_hash(email: 'b@u.ser')) }
  let(:uncompleted_task) { create_task(author_id: user_a.id, title: '未完了タスク', assignees: [user_b]) }

  context '完了タスクを検索する場合' do
    context '期間を指定しない' do
      let(:unexpected_tasks) { [uncompleted_task] }

      let(:expected_tasks) do
        [create_task(author_id: user_a.id, title: 'a', completed_at: :now, assignees: [user_b])]
      end

      it do
        get search_path(c: { from_date: nil, to_date: nil, is_signed_up_only: '0', completion_state: 'completed' })
        tasks = assigns(:tasks)
        expect(tasks).to eq(expected_tasks)
      end
    end

    context '期間の絞り込みの開始日を指定' do
      let(:unexpected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'b', completed_at: '2015-11-30'),
        ]
      end

      let(:expected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'c', completed_at: '2015-12-01'),
        ]
      end

      it do
        get search_path(c: { from_date: '2015-12-01', to_date: nil, is_signed_up_only: '0', completion_state: 'completed' })
        tasks = assigns(:tasks)
        expect(tasks).to eq(expected_tasks)
      end
    end

    context '期間の絞り込みの終了日を指定' do
      let(:unexpected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'b', completed_at: '2015-12-01'),
        ]
      end

      let(:expected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'c', completed_at: '2015-11-30 12:00'),
        ]
      end

      it do
        get search_path(c: { from_date: nil, to_date: '2015-11-30', is_signed_up_only: '0', completion_state: 'completed' })
        tasks = assigns(:tasks)
        expect(tasks).to eq(expected_tasks)
      end
    end

    context '期間の絞り込みの開始日と終了日を指定' do
      let(:unexpected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'b', completed_at: '2015-11-30'),
          create_task(author_id: user_a.id, title: 'c', completed_at: '2016-01-01'),
        ]
      end

      let(:expected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'd', completed_at: '2015-12-01'),
          create_task(author_id: user_a.id, title: 'e', completed_at: '2015-12-31'),
        ]
      end

      it do
        get search_path(c: { from_date: '2015-12-01', to_date: '2015-12-31', is_signed_up_only: '0', completion_state: 'completed' })
        tasks = assigns(:tasks)
        expect(tasks).to eq(expected_tasks)
      end
    end
  end
end
