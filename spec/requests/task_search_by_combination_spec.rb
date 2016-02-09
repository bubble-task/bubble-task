require 'rails_helper'

describe 'GET /search' do
  before do
    request_sign_in_as(user_a)
    tasks
    expected_tasks
  end

  let(:user_a) { create_user_from_oauth_credential }
  let(:user_b) { create_user_from_oauth_credential(generate_auth_hash(email: 'other@user.com')) }

  let(:tasks) do
    [
      create_task(
        title: '完了日=2016-01-01,タグ=タグA タグB,サインアップ=user_a',
        author_id: user_a.id, tags: %w(タグA タグB), completed_at: '2016-01-01', assignees: [user_a]
      ),
      create_task(
        title: '完了日=2016-01-02,タグ=タグA タグB タグC,サインアップ=user_a,user_b',
        author_id: user_a.id, tags: %w(タグA タグB タグC), completed_at: '2016-01-02', assignees: [user_a,user_b]
      ),
      create_task(
        title: '完了日=2015-12-30,タグ=タグA タグB,サインアップ=user_a',
        author_id: user_a.id, tags: %w(タグA タグB), completed_at: '2015-12-30', assignees: [user_a]
      ),
      create_task(
        title: '完了日=2016-01-03,タグ=タグA タグB,サインアップ=user_a',
        author_id: user_a.id, tags: %w(タグA タグB), completed_at: '2016-01-03', assignees: [user_a]
      ),
      create_task(
        title: '完了日=2016-01-01,タグ=なし,サインアップ=user_a,user_b',
        author_id: user_a.id, completed_at: '2016-01-01', assignees: [user_a,user_b]
      ),
      create_task(
        title: '完了日=2016-01-01,タグ=タグA タグC,サインアップ=user_b',
        author_id: user_a.id, tags: %w(タグA タグC), completed_at: '2016-01-01', assignees: [user_b]
      ),
      create_task(
        title: '完了日=2016-01-01,タグ=タグA,サインアップ=user_a,user_b',
        author_id: user_a.id, tags: %w(タグA), completed_at: '2016-01-01', assignees: [user_a,user_b]
      ),
      create_task(
        title: '完了日=2016-01-01,タグ=タグC,サインアップ=user_b',
        author_id: user_a.id, tags: %w(タグC), completed_at: '2016-01-01', assignees: [user_b]
      ),
      create_task(
        title: '未完了,タグ=タグA タグB,サインアップ=user_a',
        author_id: user_a.id, tags: %w(タグA タグB), assignees: [user_a]
      ),
      create_task(
        title: '未完了,タグ=タグA タグB,サインアップ=user_a,user_b',
        author_id: user_a.id, tags: %w(タグA タグB), assignees: [user_a,user_b]
      ),
      create_task(
        title: '未完了,タグ=タグA タグB,サインアップ=なし',
        author_id: user_a.id, tags: %w(タグA タグB),
      ),
      create_task(
        title: '未完了,期限=2016-01-01,タグ=タグB,サインアップ=user_b',
        author_id: user_a.id, tags: %w(タグB), assignees: [user_b],
        deadline: Time.zone.parse('2016-01-01'),
      ),
      create_task(
        title: '未完了,期限=2016-01-01,タグ=タグA タグB,サインアップ=user_a,user_b',
        author_id: user_a.id, tags: %w(タグA タグB), assignees: [user_a, user_b],
        deadline: Time.zone.parse('2016-02-01'),
      ),
      create_task(
        title: '未完了,期限=2016-01-02,タグ=なし,サインアップ=user_b',
        author_id: user_a.id, assignees: [user_b],
        deadline: Time.zone.parse('2016-02-12'),
      ),
    ]
  end

  context '期間を指定,自分がサインアップ=OFF,タグを複数指定,完了/未完了どちらも' do
    let(:expected_tasks) do
      [
        Task.find_by(title: '完了日=2016-01-01,タグ=タグA タグB,サインアップ=user_a'),
        Task.find_by(title: '完了日=2016-01-02,タグ=タグA タグB タグC,サインアップ=user_a,user_b'),
        # TODO: ↓コメントイン
        #Task.find_by(title: '未完了,期限=2016-01-01,タグ=タグA タグB,サインアップ=user_a,user_b'),
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
        Task.find_by(title: '完了日=2016-01-01,タグ=タグA タグB,サインアップ=user_a'),
        Task.find_by(title: '完了日=2016-01-02,タグ=タグA タグB タグC,サインアップ=user_a,user_b'),
        Task.find_by(title: '完了日=2016-01-01,タグ=なし,サインアップ=user_a,user_b'),
        Task.find_by(title: '完了日=2016-01-01,タグ=タグA タグC,サインアップ=user_b'),
        Task.find_by(title: '完了日=2016-01-01,タグ=タグA,サインアップ=user_a,user_b'),
        Task.find_by(title: '完了日=2016-01-01,タグ=タグC,サインアップ=user_b'),
      ]
    end

    it do
      get search_path(c: { from_date: '2015-12-31', to_date: '2016-01-02', is_signed_up_only: '0', completion_state: 'any' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '期間を指定,自分がサインアップ=ON,未完了のみ' do
    let(:expected_tasks) do
      [
        Task.find_by(title: '未完了,期限=2016-01-01,タグ=タグA タグB,サインアップ=user_a,user_b'),
      ]
    end

    it do
      get search_path(c: { from_date: '2016-01-15', to_date: '2016-02-01', is_signed_up_only: '1', completion_state: 'uncompleted' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context '期間を指定,自分がサインアップ=OFF,完了のみ,タグ=タグA,タグB' do
    let(:expected_tasks) do
      [
        Task.find_by(title: '完了日=2016-01-01,タグ=タグA タグB,サインアップ=user_a'),
        Task.find_by(title: '完了日=2016-01-02,タグ=タグA タグB タグC,サインアップ=user_a,user_b'),
      ]
    end

    it do
      get search_path(c: { from_date: '2016-01-01', to_date: '2016-01-02', tag_words: 'タグA タグB', is_signed_up_only: '0', completion_state: 'completed' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end
end
