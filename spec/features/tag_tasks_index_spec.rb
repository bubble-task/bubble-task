require 'rails_helper'

describe 'タスクのタグからタグに紐づくタスクの一覧ページを表示する' do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }

  it do
    create_task(user.id, 'タスクのタイトル3', nil, %w(タグ1))
    create_task(user.id, 'タスクのタイトル2', nil, %w(タグ2))
    create_task(user.id, 'タスクのタイトル1', nil, %w(タグ1))
    visit root_path
    first('.task-summary').click_link('タグ1')
    tag = first('.header .tag').text
    expect(tag).to eq('タグ1')
  end

  it do
    task_c = create_task(user.id, 'タスクのタイトルC', nil, %w(タグ3 タグ1))
    task_b = create_task(user.id, 'タスクのタイトルB', nil, %w(タグ2))
    task_a = create_task(user.id, 'タスクのタイトルA', nil, %w(タグ1 タグ2 タグ4))
    visit tasks_path(tag: 'タグ1')

    task_summary1 = all('.task-summary')[0]
    task_summary1_title = task_summary1.first('.task-title').text
    expect(task_summary1_title).to eq('タスクのタイトルC')
    task_summary1_tags = task_summary1.all('.tag').map(&:text)
    expect(task_summary1_tags).to eq(%w(タグ3 タグ1))

    task_summary2 = all('.task-summary')[1]
    task_summary2_title = task_summary2.first('.task-title').text
    expect(task_summary2_title).to eq('タスクのタイトルA')
    task_summary2_tags = task_summary2.all('.tag').map(&:text)
    expect(task_summary2_tags).to eq(%w(タグ1 タグ2 タグ4))
  end
end
