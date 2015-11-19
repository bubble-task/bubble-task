require 'rails_helper'

describe 'タスクを作成する' do
  before do
    oauth_sign_in
    visit new_task_path
  end

  let(:label_title) { I18n.t('activemodel.attributes.task_creation.title') }
  let(:label_description) { I18n.t('activemodel.attributes.task_creation.description') }
  let(:label_tag_words) { I18n.t('activemodel.attributes.task_creation.tag_words') }

  let(:title) { 'タスクのタイトル' }
  let(:description) { 'タスクの説明' }

  let(:title_on_page) { first('.task_title').text }
  let(:description_on_page) { first('.task_description').text }
  let(:tags_on_page) { first('.tags').text.split(/\s+/) }

  context 'タイトルのみの場合' do
    it do
      fill_in label_title, with: title
      click_button '作成する'
      click_link title
      expect(title_on_page).to eq(title)
      expect(description_on_page).to eq ''
    end
  end

  context '説明を記述する場合' do
    it do
      fill_in label_title, with: title
      fill_in label_description, with: description
      click_button '作成する'
      click_link title
      expect(title_on_page).to eq(title)
      expect(description_on_page).to eq(description)
    end
  end

  context 'タグを付加する場合' do
    it 'タスク一覧画面でタグが表示されていること' do
      fill_in label_tag_words, with: 'タグ1 タグ2 タグ3'
      fill_in label_title, with: title
      click_button '作成する'
      expect(tags_on_page).to eq %w(タグ1 タグ2 タグ3)
    end

    it 'タスク詳細画面でタグが表示されていること' do
      fill_in label_tag_words, with: 'タグ1 タグ2 タグ3'
      fill_in label_title, with: title
      click_button '作成する'
      click_link title
      expect(tags_on_page).to eq %w(タグ1 タグ2 タグ3)
    end

    context 'タグが重複している場合' do
      it do
        fill_in label_tag_words, with: 'タグ1 タグ2 タグ1'
        fill_in label_title, with: title
        click_button '作成する'
        expect(tags_on_page).to eq %w(タグ1 タグ2)
      end
    end

    context '複数のタスクに同じタグを付加する場合' do
      it do
        fill_in label_tag_words, with: 'タグ'
        fill_in label_title, with: 'タスク1のタイトル'
        click_button '作成する'
        task1 = Task.last
        visit new_task_path
        fill_in label_tag_words, with: 'タグ'
        fill_in label_title, with: 'タスク2のタイトル'
        click_button '作成する'
        task2 = Task.last
        task1_tag_on_page = first("#task_#{task1.id} .tags").text
        task2_tag_on_page = first("#task_#{task2.id} .tags").text
        expect(task1_tag_on_page).to eq('タグ')
        expect(task2_tag_on_page).to eq('タグ')
      end
    end
  end
end
