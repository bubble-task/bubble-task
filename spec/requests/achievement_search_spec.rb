require 'rails_helper'

describe 'GET /achievements' do
  before do
    request_sign_in_as(user)
    expected_tasks
    unexpected_tasks
    other_users_task
  end

  let(:user) { create_user_from_oauth_credential }

  let(:uncompleted_task) { create_task(author_id: user.id, title: '未完了タスク') }

  let(:other_users_task) do
    other_user = create_user_from_oauth_credential(generate_auth_hash(email: 'other@user.com'))
    create_task(author_id: other_user.id, title: '他ユーザのタスク')
  end

  context '期間を指定しない' do
    let(:unexpected_tasks) { [uncompleted_task] }

    let(:expected_tasks) do
      [create_task(author_id: user.id, title: 'a', completed_at: :now)]
    end

    it do
      get achievements_path(c: { from_date: nil, to_date: nil })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '期間の絞り込みの開始日を指定' do
    let(:unexpected_tasks) do
      [
        uncompleted_task,
        create_task(author_id: user.id, title: 'b', completed_at: '2015-11-30'),
      ]
    end

    let(:expected_tasks) do
      [
        create_task(author_id: user.id, title: 'c', completed_at: '2015-12-01'),
      ]
    end

    it do
      get achievements_path(c: { from_date: '2015-12-01', to_date: nil })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '期間の絞り込みの終了日を指定' do
    let(:unexpected_tasks) do
      [
        uncompleted_task,
        create_task(author_id: user.id, title: 'b', completed_at: '2015-12-01'),
      ]
    end

    let(:expected_tasks) do
      [
        create_task(author_id: user.id, title: 'c', completed_at: '2015-11-30 12:00'),
      ]
    end

    it do
      get achievements_path(c: { from_date: nil, to_date: '2015-11-30' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '期間の絞り込みの開始日と終了日を指定' do
    let(:unexpected_tasks) do
      [
        uncompleted_task,
        create_task(author_id: user.id, title: 'b', completed_at: '2015-11-30'),
        create_task(author_id: user.id, title: 'c', completed_at: '2016-01-01'),
      ]
    end

    let(:expected_tasks) do
      [
        create_task(author_id: user.id, title: 'd', completed_at: '2015-12-01'),
        create_task(author_id: user.id, title: 'e', completed_at: '2015-12-31'),
      ]
    end

    it do
      get achievements_path(c: { from_date: '2015-12-01', to_date: '2015-12-31' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '検索結果は並び順' do
    let(:unexpected_tasks) { [uncompleted_task] }

    let(:expected_tasks) { [task2, task3, task1] }
    let(:expected_ordered_tasks) { [task1, task2, task3] }

    let(:task1) { create_task(author_id: user.id, title: '1', completed_at: '2015-12-01 00:00:00') }
    let(:task2) { create_task(author_id: user.id, title: '2', completed_at: '2015-12-01 00:00:01') }
    let(:task3) { create_task(author_id: user.id, title: '3', completed_at: '2015-12-05') }

    it do
      get achievements_path(c: { from_date: '2015-12-01', to_date: '2015-12-31' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_ordered_tasks)
    end
  end
end
