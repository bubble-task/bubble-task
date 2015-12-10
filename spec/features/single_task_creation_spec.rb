require 'rails_helper'

describe 'タスクを作成する' do
  before do
    oauth_sign_in
  end

  let(:title) { 'タスクのタイトル' }
  let(:description) { 'タスクの説明' }

  let(:title_on_page) { first('.task-title').text }
  let(:description_on_page) { first('.task-description').text }
  let(:tags_on_page) { first('.tags').text.split(/\s+/) }

  context 'タイトルのみの場合' do
    it do
      create_task_from_ui(title: title)
      click_link title
      expect(title_on_page).to eq(title)
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

  context 'タグを選んでから作成する場合' do
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
end
