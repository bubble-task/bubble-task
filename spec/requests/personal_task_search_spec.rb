require 'rails_helper'

describe 'GET /search' do
  before do
    request_sign_in_as(user)
    expected_tasks
    unexpected_tasks
  end

  let(:user) { create_user_from_oauth_credential }
  let(:other_user) { create_user_from_oauth_credential(generate_auth_hash(email: 'other_user@gaiax.com')) }

  context '期間指定なし&タグ指定なし&完了・未完了どちらも&自分がサインアップOFFで検索' do
    let(:expected_tasks) do
      [
        create_personal_task(user_id: user.id, title: '個人タスク'),
        create_task(author_id: user.id, title: '公開タスク1', tags: %w(TagA), assignees: [user]),
        create_task(author_id: other_user.id, title: '公開タスク2', tags: %w(TagB), assignees: [other_user]),
      ]
    end

    let(:unexpected_tasks) do
      [create_personal_task(user_id: other_user.id, title: '他人の個人タスク')]
    end

    it do
      get search_path(c: { is_signed_up_only: nil, completion_state: 'any' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '期間指定あり&タグ指定なし&完了のみ&自分がサインアップOFFで検索' do
    let(:expected_tasks) do
      [
        create_personal_task(user_id: user.id, title: '個人タスク', completed_at: '2016-02-01'),
        create_task(author_id: user.id, title: '公開タスク1', tags: %w(TagA), assignees: [user], completed_at: '2016/02/01'),
        create_task(author_id: other_user.id, title: '公開タスク2', tags: %w(TagB), assignees: [other_user], completed_at: '2016/02/02'),
      ]
    end

    let(:unexpected_tasks) do
      [
        create_personal_task(user_id: other_user.id, title: '他人の個人タスク', completed_at: '2016-02-02'),
        create_task(author_id: other_user.id, title: '公開タスク3', tags: %w(TagA TagB), assignees: [other_user], completed_at: '2016/02/03'),
      ]
    end

    it do
      get search_path(c: { from_date: '2016-02-01', to_date: '2016-02-02', is_signed_up_only: '0', completion_state: 'completed' })
      expect(assigned_task_ids).to match_array(expected_tasks.map(&:id))
    end
  end

  context '期間指定あり&タグ指定あり&完了・未完了どちらも&自分がサインアップOFFで検索' do
    let(:expected_tasks) do
      [
        create_task(author_id: user.id, title: '公開タスク1', tags: %w(TagA TagB), assignees: [user], completed_at: '2016/02/01'),
        create_task(author_id: other_user.id, title: '公開タスク2', tags: %w(TagB TagC), assignees: [other_user], deadline: Time.zone.parse('2016/02/02')),
      ]
    end

    let(:unexpected_tasks) do
      [
        create_personal_task(user_id: user.id, title: '個人タスク', completed_at: '2016-02-01'),
        create_personal_task(user_id: other_user.id, title: '他人の個人タスク', completed_at: '2016-02-02'),
        create_task(author_id: other_user.id, title: '公開タスク3', tags: %w(TagA TagC), assignees: [other_user], completed_at: '2016/02/02'),
      ]
    end

    it do
      get search_path(c: { from_date: '2016-02-01', to_date: '2016-02-02', tag_words: 'TagB', is_signed_up_only: '0', completion_state: 'any' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '期間指定なし&タグ指定なし&未完了のみ&自分がサインアップONで検索 ' do
    let(:expected_tasks) do
      [
        create_personal_task(user_id: user.id, title: '個人タスク'),
        create_task(author_id: user.id, title: '公開タスク1', tags: %w(TagA), assignees: [user]),
      ]
    end

    let(:unexpected_tasks) do
      [
        create_personal_task(user_id: other_user.id, title: '他人の個人タスク'),
        create_personal_task(user_id: user.id, title: '完了個人タスク', completed_at: :now),
        create_task(author_id: other_user.id, title: '公開タスク3', tags: %w(TagA TagC), assignees: [user, other_user], completed_at: '2016/02/02'),
      ]
    end

    it do
      get search_path(c: { is_signed_up_only: '1', completion_state: 'uncompleted' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end
end
