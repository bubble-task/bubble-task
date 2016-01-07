require 'rails_helper'

describe 'GET /achievements' do
  before do
    request_sign_in_as(assignee)
    expected_tasks
    unexpected_tasks
    other_users_completed_task
  end

  let(:task_author) { create_user_from_oauth_credential(generate_auth_hash(email: 'task@auth.or')) }
  let(:assignee) { create_user_from_oauth_credential }
  let(:uncompleted_task) { create_task(author_id: task_author.id, title: '未完了タスク', assignees: [assignee]) }

  let(:other_users_completed_task) do
    create_user_from_oauth_credential(generate_auth_hash(email: 'other@user.com')).tap do |u|
      create_task(author_id: u.id, title: '他ユーザのタスク', completed_at: :now, assignees: [u])
    end
  end

  context 'タグを指定しない場合' do
    let(:unexpected_tasks) { [uncompleted_task] }

    let(:expected_tasks) do
      [create_task(author_id: task_author.id, title: 'a', completed_at: :now, assignees: [assignee])]
    end

    it do
      get achievements_path(c: { from_date: nil, to_date: nil })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context 'タグを1つ指定する場合' do
    let(:unexpected_tasks) do
      [
        uncompleted_task,
        create_task(author_id: task_author.id, title: 'a', tags: ['指定しないタグ'], completed_at: :now, assignees: [assignee])
      ]
    end

    let(:expected_tasks) do
      [create_task(author_id: task_author.id, title: 'a', tags: ['指定するタグ'], completed_at: :now, assignees: [assignee])]
    end

    it do
      get achievements_path(c: { from_date: nil, to_date: nil, tag_words: '指定するタグ' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end

  context 'タグを2つ指定する場合' do
    let(:unexpected_tasks) do
      [
        uncompleted_task,
        create_task(author_id: task_author.id, title: '1', tags: %w(タグA), completed_at: :now, assignees: [assignee]),
        create_task(author_id: task_author.id, title: '2', tags: %w(タグB), completed_at: :now, assignees: [assignee]),
        create_task(author_id: task_author.id, title: '3', tags: %w(タグB タグC), completed_at: :now, assignees: [assignee]),
      ]
    end

    let(:expected_tasks) do
      [create_task(author_id: task_author.id, title: '4', tags: %w(タグA タグB), completed_at: :now, assignees: [assignee])]
    end

    it do
      get achievements_path(c: { from_date: nil, to_date: nil, tag_words: 'タグA タグB' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end
end
