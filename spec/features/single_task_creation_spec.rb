require 'rails_helper'

describe 'タスクを作成する' do
  before do
    sign_in_as(user)
  end

  let(:user) { create_user_from_oauth_credential }

  let(:title) { 'タスクのタイトル' }
  let(:description) { 'タスクの説明' }

  let(:title_on_page) { first('.task-title').text }
  let(:description_on_page) { first('.task-description').text }
  let(:tags_on_page) { first('.tags').text.split(/\s+/) }

  context 'タイトルのみの場合' do
    let(:deadline_text) { first('.task-deadline').text }

    it do
      create_task_from_ui(title: title)
      click_link title
      expect(title_on_page).to eq(title)
    end

    it 'タスクの期限は設定されないこと' do
      create_task_from_ui(title: title)
      expect(deadline_text).to be_empty
    end
  end

  context '説明を記述する場合' do
    it do
      create_task_from_ui(title: title, description: description)
      click_link title
      expect(title_on_page).to eq(title)
      expect(description_on_page).to eq(description)
    end
  end

  context 'タグを付加する場合' do
    before do
      create_task_from_ui(title: title, tag_words: tag_words)
      TaskAssignment.new(task: Task.last, assignee: User.last).run
      visit root_path
    end

    context '全て違うタグを入力する' do
      let(:tag_words) { 'タグ1 タグ2 タグ3' }

      it 'タスク一覧画面でタグが表示されていること' do
        expect(tags_on_page).to eq %w(タグ1 タグ2 タグ3)
      end

      it 'タスク詳細画面でタグが表示されていること' do
        click_link title
        expect(tags_on_page).to eq %w(タグ1 タグ2 タグ3)
      end
    end

    context 'タグが重複している場合' do
      let(:tag_words) { 'タグ1 タグ2 タグ1' }

      it do
        expect(tags_on_page).to eq %w(タグ1 タグ2)
      end
    end
  end

  context 'タグを付加しない場合' do
    let(:tags_on_page) { first('.tag-personal').text.split(/\s+/) }

    it do
      create_task_from_ui(title: title)
      expect(tags_on_page).to eq %w(個人タスク)
    end

    it do
      create_task_from_ui(title: title)
      click_link(title)
      expect(tags_on_page).to eq %w(個人タスク)
    end
  end

  context '作成と同時にサインアップする場合', js: true do
    let(:assignee_avatar) { find(".assignee_#{user.id}") }

    it do
      create_task_from_ui(title: title, tag_words: 'タグ1', with_sign_up: true)
      expect(title_on_page).to eq(title)
      expect(assignee_avatar).to_not be_nil
    end
  end

  context '作成と同時にサインアップをしない場合' do
    let(:assignee_avatar) { first(".assignee_#{user.id}") }

    it do
      create_task_from_ui(title: title, tag_words: 'タグ1')
      visit tasks_path(tag: 'タグ1')
      expect(title_on_page).to eq(title)
      expect(assignee_avatar).to be_nil
    end
  end

  context 'タグのタスク一覧画面から作成する' do
    before do
      task
      visit tasks_path(tag: tag)
    end

    let(:user) { create_user_from_oauth_credential(generate_auth_hash) }
    let(:task) { create_task(author_id: user.id, title: 'タスクのタイトル', tags: [tag]) }
    let(:tag) { 'タグ' }

    it do
      first('.btn-floating').click
      selected_tag_words = find('#task_tag_words', visible: false).value
      expect(selected_tag_words).to eq(tag)
    end
  end

  context 'タグ一覧から作成する' do
    before do
      task
      visit tags_path
    end

    let(:user) { create_user_from_oauth_credential(generate_auth_hash) }
    let(:task) { create_task(author_id: user.id, title: 'タスクのタイトル', tags: [tag]) }
    let(:tag) { 'タグ' }

    it do
      first('.task_creation_on_tags').click
      selected_tag_words = find('#task_tag_words', visible: false).value
      expect(selected_tag_words).to eq(tag)
    end
  end

  context 'タスクに期限を設定する場合' do
    let(:deadline_text) { first('.task-deadline').text }

    context '分を指定しない場合' do
      let(:deadline) { Time.zone.parse('2016/02/03 10:00') }

      it do
        create_task_from_ui(title: title, deadline: deadline)
        expect(deadline_text).to eq('2016/02/03 10:00')
      end

      it do
        create_task_from_ui(title: title, deadline: deadline)
        click_link title
        expect(deadline_text).to eq('2016/02/03 10:00')
      end
    end

    context '日付のみ指定する場合' do
      let(:deadline) { { date: '2016/02/03' } }

      it do
        create_task_from_ui(title: title, deadline: deadline)
        expect(deadline_text).to eq('2016/02/03 00:00')
      end

      it do
        create_task_from_ui(title: title, deadline: deadline)
        click_link title
        expect(deadline_text).to eq('2016/02/03 00:00')
      end
    end
  end
end
