require 'rails_helper'

describe 'GET /search' do
  before do
    request_sign_in_as(user_b)
    expected_tasks
    unexpected_tasks
  end

  let(:user_a) { create_user_from_oauth_credential(generate_auth_hash(email: 'a@gaiax.com')) }
  let(:user_b) { create_user_from_oauth_credential(generate_auth_hash(email: 'b@gaiax.com')) }
  let(:uncompleted_task) { create_task(author_id: user_a.id, title: '未完了タスク', assignees: [user_b]) }

  let(:expected_task_ids) { expected_tasks.map(&:id) }

  context '完了タスクを検索する場合' do
    context '期間を指定しない' do
      let(:unexpected_tasks) { [uncompleted_task] }

      let(:expected_tasks) do
        [create_task(author_id: user_a.id, title: 'a', tags: %w(tag), completed_at: :now, assignees: [user_b])]
      end

      it do
        get search_path(c: { from_date: nil, to_date: nil, is_signed_up_only: '0', completion_state: 'completed' })
        expect(assigned_task_ids).to match_array(expected_task_ids)
      end
    end

    context '期間の絞り込みの開始日を指定' do
      let(:unexpected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'b', tags: %w(tag), completed_at: '2015-11-30', assignees: [user_a]),
        ]
      end

      let(:expected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'c', tags: %w(tag), completed_at: '2015-12-01', assignees: [user_a]),
        ]
      end

      it do
        get search_path(c: { from_date: '2015-12-01', to_date: nil, is_signed_up_only: '0', completion_state: 'completed' })
        expect(assigned_task_ids).to match_array(expected_task_ids)
      end
    end

    context '期間の絞り込みの終了日を指定' do
      let(:unexpected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'b', tags: %w(tag), completed_at: '2015-12-01', assignees: [user_a]),
        ]
      end

      let(:expected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'c', tags: %w(tag), completed_at: '2015-11-30 12:00', assignees: [user_a]),
        ]
      end

      it do
        get search_path(c: { from_date: nil, to_date: '2015-11-30', is_signed_up_only: '0', completion_state: 'completed' })
        expect(assigned_task_ids).to match_array(expected_task_ids)
      end
    end

    context '期間の絞り込みの開始日と終了日を指定' do
      let(:unexpected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'b', tags: %w(tag), completed_at: '2015-11-30', assignees: [user_a]),
          create_task(author_id: user_a.id, title: 'c', tags: %w(tag), completed_at: '2016-01-01', assignees: [user_a]),
        ]
      end

      let(:expected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'd', tags: %w(tag), completed_at: '2015-12-01', assignees: [user_a]),
          create_task(author_id: user_a.id, title: 'e', tags: %w(tag), completed_at: '2015-12-31', assignees: [user_a]),
        ]
      end

      it do
        get search_path(c: { from_date: '2015-12-01', to_date: '2015-12-31', is_signed_up_only: '0', completion_state: 'completed' })
        expect(assigned_task_ids).to match_array(expected_task_ids)
      end
    end
  end

  context '未完了タスクを検索する場合' do
    context '期間を指定しない' do
      let(:unexpected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'a', tags: %w(tag), completed_at: '2015-11-30', assignees: [user_a]),
        ]
      end

      let(:expected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'b', tags: %w(tag), deadline: Time.zone.parse('2015-11-30')),
          create_task(author_id: user_a.id, title: 'c', tags: %w(tag)),
        ]
      end

      it do
        get search_path(c: { from_date: nil, to_date: nil, is_signed_up_only: '0', completion_state: 'uncompleted' })
        expect(assigned_task_ids).to match_array(expected_task_ids)
      end
    end

    context '開始日だけの場合' do
      let(:unexpected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'a', tags: %w(tag), completed_at: '2015-11-30', assignees: [user_a]),
          create_task(author_id: user_a.id, title: 'b', tags: %w(tag), deadline: Time.zone.parse('2015-11-30')),
        ]
      end

      let(:expected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'c', tags: %w(tag), deadline: Time.zone.parse('2015-12-01')),
        ]
      end

      it do
        get search_path(c: { from_date: '2015-12-01', to_date: nil, is_signed_up_only: '0', completion_state: 'uncompleted' })
        expect(assigned_task_ids).to match_array(expected_task_ids)
      end
    end

    context '終了日だけを指定' do
      let(:unexpected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'a', tags: %w(tag), completed_at: '2015-11-30', assignees: [user_a]),
          create_task(author_id: user_a.id, title: 'b', tags: %w(tag), deadline: Time.zone.parse('2015-12-01')),
        ]
      end

      let(:expected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'c', tags: %w(tag), deadline: Time.zone.parse('2015-11-30')),
        ]
      end

      it do
        get search_path(c: { from_date: nil, to_date: '2015-11-30', is_signed_up_only: '0', completion_state: 'uncompleted' })
        expect(assigned_task_ids).to match_array(expected_task_ids)
      end
    end

    context '期間の絞り込みの開始日と終了日を指定' do
      let(:unexpected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'a', tags: %w(tag), completed_at: '2015-12-01', assignees: [user_a]),
          create_task(author_id: user_a.id, title: 'b', tags: %w(tag), completed_at: '2015-12-31', assignees: [user_a]),
          create_task(author_id: user_a.id, title: 'c', tags: %w(tag), deadline: Time.zone.parse('2015-11-30')),
          create_task(author_id: user_a.id, title: 'd', tags: %w(tag), deadline: Time.zone.parse('2016-01-01')),
        ]
      end

      let(:expected_tasks) do
        [
          create_task(author_id: user_a.id, title: 'e', tags: %w(tag), deadline: Time.zone.parse('2015-12-01')),
          create_task(author_id: user_a.id, title: 'f', tags: %w(tag), deadline: Time.zone.parse('2015-12-31')),
        ]
      end

      it do
        get search_path(c: { from_date: '2015-12-01', to_date: '2015-12-31', is_signed_up_only: '0', completion_state: 'uncompleted' })
        expect(assigned_task_ids).to match_array(expected_task_ids)
      end
    end
  end
end
