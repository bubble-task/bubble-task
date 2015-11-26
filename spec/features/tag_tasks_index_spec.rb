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

  describe '各一覧画面からの遷移' do
    before do
      create_task(user.id, 'タスクのタイトル', nil, %w(タグ))
    end

    let(:tag_at_header) { first('.header .tag').text }

    context 'タスク一覧のタグをクリックした場合' do
      it do
        visit root_path
        click_link('タグ')
        expect(tag_at_header).to eq('タグ')
      end
    end

    context 'タグ一覧のタグをクリックした場合' do
      it do
        visit tags_path
        click_link('タグ')
        expect(tag_at_header).to eq('タグ')
      end
    end
  end

  describe 'タグに紐づくタスク一覧画面の表示' do
    it do
      create_task(user.id, 'タスクのタイトルC', nil, %w(タグ3 タグ1))
      create_task(user.id, 'タスクのタイトルB', nil, %w(タグ2))
      create_task(user.id, 'タスクのタイトルA', nil, %w(タグ1 タグ2 タグ4))
      visit tasks_path(tag: 'タグ1')

      task_summary1 = task_summary_by_order(1)
      expect(task_summary1[:title]).to eq('タスクのタイトルC')
      expect(task_summary1[:tags]).to eq(%w(タグ3 タグ1))

      task_summary2 = task_summary_by_order(2)
      expect(task_summary2[:title]).to eq('タスクのタイトルA')
      expect(task_summary2[:tags]).to eq(%w(タグ1 タグ2 タグ4))
    end
  end
end
