require 'rails_helper'

describe 'GET /search' do
  before do
    request_sign_in_as(user)
    tasks
  end

  let(:user) { create_user_from_oauth_credential }

  let(:tasks) do
    [
      create_task(
        author_id: user.id, title: '期限なし,作成順1', tags: ['tag'], assignees: [user]
      ),
      create_task(
        author_id: user.id, title: '期限なし,作成順2', tags: ['tag'], assignees: [user]
      ),
      create_task(
        author_id: user.id, title: '期限なし,作成順3', tags: ['tag'], assignees: [user]
      ),
      create_task(
        author_id: user.id, title: '期限=2016-01-03',
        deadline: Time.zone.parse('2016-01-03'), tags: ['tag'], assignees: [user]
      ),
      create_task(
        author_id: user.id, title: '期限=2016-01-01',
        deadline: Time.zone.parse('2016-01-01'), tags: ['tag'], assignees: [user]
      ),
      create_task(
        author_id: user.id, title: '期限=2016-01-02',
        deadline: Time.zone.parse('2016-01-02'), tags: ['tag'], assignees: [user]
      ),
      create_task(
        author_id: user.id, title: '完了=2016-01-03,期限なし',
        completed_at: '2016-01-03', tags: ['tag'], assignees: [user]
      ),
      create_task(
        author_id: user.id, title: '完了=2016-01-01,期限なし',
        completed_at: '2016-01-01', tags: ['tag'], assignees: [user]
      ),
      create_task(
        author_id: user.id, title: '完了=2016-01-02,期限なし',
        completed_at: '2016-01-02', tags: ['tag'], assignees: [user]
      ),
    ]
  end

  let(:expected_tasks) do
    [
      Task.find_by(title: '完了=2016-01-01,期限なし'),
      Task.find_by(title: '完了=2016-01-02,期限なし'),
      Task.find_by(title: '完了=2016-01-03,期限なし'),
      Task.find_by(title: '期限=2016-01-01'),
      Task.find_by(title: '期限=2016-01-02'),
      Task.find_by(title: '期限=2016-01-03'),
      Task.find_by(title: '期限なし,作成順1'),
      Task.find_by(title: '期限なし,作成順2'),
      Task.find_by(title: '期限なし,作成順3'),
    ]
  end

  it 'タスクの完了日の昇順,期限の昇順,作成日時の昇順に並んでいること' do
    get search_path(c: { from_date: nil, to_date: nil, is_signed_up_only: '0' })
    tasks = assigns(:tasks)
    expect(tasks).to eq(expected_tasks)
  end
end
