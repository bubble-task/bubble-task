require 'rails_helper'

describe '自身が作成したタスクの一覧' do
  let(:user_a_auth_hash) { generate_auth_hash }
  let(:user_a) { create_user_from_oauth_credential(user_a_auth_hash) }
  let(:user_b) { create_user_from_oauth_credential(generate_auth_hash) }
  let(:create_task_for_user_b) { create_task(author_id: user_b.id, title: 'ユーザBのタスク') }

  before do
    user_a
    user_b
  end

  it do
    create_task_for_user_b

    oauth_sign_in(auth_hash: user_a_auth_hash)
    visit root_path
    expect(page).to_not have_link('ユーザBのタスク')
  end

  it do
    task = create_task(author_id: user_b.id, title: 'ユーザBのタスク', tags: ['タグ'])
    TaskAssignment.new(task: task, assignee: user_a).run

    oauth_sign_in(auth_hash: user_a_auth_hash)
    visit root_path
    expect(page).to have_link(task.title)
  end

  it do
    task = create_task(author_id: user_b.id, title: 'ユーザBのタスク', tags: %w(タグ1 タグ2))
    TaskAssignment.new(task: task, assignee: user_a).run

    oauth_sign_in(auth_hash: user_a_auth_hash)
    visit root_path
    task_summaries = all('.task-summary')
    expect(task_summaries.size).to eq(1)
  end

  it do
    task = create_task(author_id: user_a.id, title: 'ユーザAのタスク')
    oauth_sign_in(auth_hash: user_a_auth_hash)
    visit root_path
    expect(page).to have_link(task.title)
  end

  it do
    task = create_task(author_id: user_a.id, title: 'ユーザAのタスク', tags: ['タグ'])
    oauth_sign_in(auth_hash: user_a_auth_hash)
    visit root_path
    expect(page).to_not have_link(task.title)
  end
end
