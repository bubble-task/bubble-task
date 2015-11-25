require 'rails_helper'

describe 'タスクのタグからタグに紐づくタスクの一覧ページを表示する' do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }

  def task_summary_by_order(order)
    index = order - 1
    task_summary = all('.task-summary')[index]
    {
      title: task_summary.first('.task-title').text,
      tags: task_summary.all('.tag').map(&:text),
    }
  end

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

    task_summary1 = task_summary_by_order(1)
    expect(task_summary1[:title]).to eq('タスクのタイトルC')
    expect(task_summary1[:tags]).to eq(%w(タグ3 タグ1))

    task_summary2 = task_summary_by_order(2)
    expect(task_summary2[:title]).to eq('タスクのタイトルA')
    expect(task_summary2[:tags]).to eq(%w(タグ1 タグ2 タグ4))
  end
end
