require 'rails_helper'

describe 'タスクを作成する' do
  before do
    oauth_sign_in
    visit new_task_path
  end

  let(:title) { 'タスクのタイトル' }
  let(:description) { 'タスクの説明' }

  let(:title_on_page) { first('.task_title').text }
  let(:description_on_page) { first('.task_description').text }
  let(:tags_on_page) { first('.tags').text.split(/\s+/) }

  def create_task(title, description = '', tag_words = '')
      fill_in I18n.t('activemodel.attributes.task_creation.title'), with: title
      fill_in I18n.t('activemodel.attributes.task_creation.description'), with: description
      fill_in I18n.t('activemodel.attributes.task_creation.tag_words'), with: tag_words
      click_button '作成する'
  end

  context 'タイトルのみの場合' do
    it do
      create_task(title)
      click_link title
      expect(title_on_page).to eq(title)
      expect(description_on_page).to eq ''
    end
  end

  context '説明を記述する場合' do
    it do
      create_task(title, description)
      click_link title
      expect(title_on_page).to eq(title)
      expect(description_on_page).to eq(description)
    end
  end

  context 'タグを付加する場合' do
    before do
      create_task(title, nil, tag_words)
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
end
