require 'rails_helper'

describe 'タスクの並び順' do
  include TaskElementHelper

  before do
    sign_in_as(user)
    tasks
  end

  let(:user) { create_user_from_oauth_credential }
  let(:create_task_for_user_b) { create_task(author_id: user_b.id, title: 'ユーザBのタスク') }
  let(:tasks) do
    [
      create_task(author_id: user.id, title: '期限なし,作成順1', tags: ['tag'], assignees: [user]),
      create_task(author_id: user.id, title: '期限なし,作成順2', tags: ['tag'], assignees: [user]),
      create_task(author_id: user.id, title: '期限なし,作成順3', tags: ['tag'], assignees: [user]),
      create_task(author_id: user.id, title: '期限=2016-01-03', tags: ['tag'], assignees: [user], deadline: Time.zone.parse('2016-01-03')),
      create_task(author_id: user.id, title: '期限=2016-01-01', tags: ['tag'], assignees: [user], deadline: Time.zone.parse('2016-01-01')),
      create_task(author_id: user.id, title: '期限=2016-01-02', tags: ['tag'], assignees: [user], deadline: Time.zone.parse('2016-01-02')),
    ]
  end

  let(:expected_task_css_ids) do
    [
      task_css_id(Task.find_by(title: '期限=2016-01-01').id),
      task_css_id(Task.find_by(title: '期限=2016-01-02').id),
      task_css_id(Task.find_by(title: '期限=2016-01-03').id),
      task_css_id(Task.find_by(title: '期限なし,作成順1').id),
      task_css_id(Task.find_by(title: '期限なし,作成順2').id),
      task_css_id(Task.find_by(title: '期限なし,作成順3').id),
    ]
  end

  let(:task_css_ids) { all('.task-summary').map { |t| t[:id] } }

  context 'ホーム画面' do
    it do
      visit root_path
      expect(task_css_ids).to eq(expected_task_css_ids)
    end
  end

  context 'タグのタスク一覧' do
    it do
      visit tasks_path(tag: 'tag')
      expect(task_css_ids).to eq(expected_task_css_ids)
    end
  end
end
