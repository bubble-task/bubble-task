require 'rails_helper'

describe 'GET /achievements' do
  before do
    request_sign_in_as(assignee)
    expected_tasks
    unexpected_tasks
  end

  let(:assignee) { create_user_from_oauth_credential }

  context '' do
    let(:expected_tasks) do
      [create_task(author_id: assignee.id, title: 'タスクA', tags: %w(タグA タグB), completed_at: '2016-01-01', assignees: [assignee])]
    end

    let(:unexpected_tasks) do
      [
        create_task(author_id: assignee.id, title: 'タスクB', tags: %w(タグA タグB), completed_at: '2015-12-30', assignees: [assignee]),
        create_task(author_id: assignee.id, title: 'タスクC', tags: %w(タグA タグB), completed_at: '2016-01-03', assignees: [assignee]),
        create_task(author_id: assignee.id, title: 'タスクD', completed_at: '2016-01-01', assignees: [assignee]),
        create_task(author_id: assignee.id, title: 'タスクE', tags: %w(タグA タグC), completed_at: '2016-01-01', assignees: [assignee]),
        create_task(author_id: assignee.id, title: 'タスクF', tags: %w(タグA), completed_at: '2016-01-01', assignees: [assignee]),
        create_task(author_id: assignee.id, title: 'タスクG', tags: %w(タグC), completed_at: '2016-01-01', assignees: [assignee]),
      ]
    end

    it do
      get achievements_path(c: { from_date: '2015-12-31', to_date: '2016-01-02', tag_words: 'タグA タグB' })
      tasks = assigns(:tasks)
      expect(tasks).to eq(expected_tasks)
    end
  end
end
