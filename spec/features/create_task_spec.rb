require 'rails_helper'

describe 'タスクを作成する' do
  before do
    oauth_sign_in
    visit new_task_path
  end

  context 'タイトルのみの場合' do
    it do
      fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスクのタイトル'
      click_button '作成する'
      click_link 'タスクのタイトル'
      title = find('#task_title').text
      description = find('#task_description').text
      expect(title).to eq 'タスクのタイトル'
      expect(description).to eq ''
    end
  end

  context '説明を記述する場合' do
    it do
      fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスクのタイトル'
      fill_in I18n.t('activemodel.attributes.task_creation.description'), with: 'タスクの説明'
      click_button '作成する'
      click_link 'タスクのタイトル'
      title = find('#task_title').text
      description = find('#task_description').text
      expect(title).to eq 'タスクのタイトル'
      expect(description).to eq 'タスクの説明'
    end
  end

  context 'タグを付加する場合' do
    it do
      fill_in I18n.t('activemodel.attributes.task_creation.tag_words'), with: 'タグ1 タグ2 タグ3'
      fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスクのタイトル'
      click_button '作成する'
      tags = first('.tags').text.split(/\s+/)
      expect(tags).to eq %w(タグ1 タグ2 タグ3)
    end

    it do
      fill_in I18n.t('activemodel.attributes.task_creation.tag_words'), with: 'タグ1 タグ2 タグ3'
      fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスクのタイトル'
      click_button '作成する'
      click_link 'タスクのタイトル'
      tags = find('#tags').text.split(/\s+/)
      expect(tags).to eq %w(タグ1 タグ2 タグ3)
    end

    context 'タグが重複している場合' do
      it do
        fill_in I18n.t('activemodel.attributes.task_creation.tag_words'), with: 'タグ1 タグ2 タグ1'
        fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスクのタイトル'
        click_button '作成する'
        tags = first('.tags').text.split(/\s+/)
        expect(tags).to eq %w(タグ1 タグ2)
      end
    end

    context '複数のタスクに同じタグを付加する場合' do
      it do
        fill_in I18n.t('activemodel.attributes.task_creation.tag_words'), with: 'タグ'
        fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスク1のタイトル'
        click_button '作成する'
        task1 = Task.last
        visit new_task_path
        fill_in I18n.t('activemodel.attributes.task_creation.tag_words'), with: 'タグ'
        fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスク2のタイトル'
        click_button '作成する'
        task2 = Task.last
        task1_tag = first("#task_#{task1.id} .tags").text
        task2_tag = first("#task_#{task2.id} .tags").text
        expect(task1_tag).to eq('タグ')
        expect(task2_tag).to eq('タグ')
      end
    end
  end
end
