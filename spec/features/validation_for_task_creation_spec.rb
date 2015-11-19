require 'rails_helper'

describe 'タスク作成時にバリデーションをかける' do
  before do
    oauth_sign_in
    visit new_task_path
  end

  it do
    fill_in I18n.t('activemodel.attributes.task_creation.title'), with: ''
    click_button '作成する'
    expect(page).to have_content 'タイトルを入力してください'
  end

  it do
    title = 'a' * 40
    fill_in I18n.t('activemodel.attributes.task_creation.title'), with: title
    click_button '作成する'
    expect(page).to have_link(title)
  end

  it do
    fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'a' * 41
    click_button '作成する'
    expect(page).to have_content 'タイトルは40文字以内で入力してください'
  end

  it do
    fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスクのタイトル'
    fill_in I18n.t('activemodel.attributes.task_creation.description'), with: 'a' * 256
    click_button '作成する'
    expect(page).to have_content '説明は255文字以内で入力してください'
  end

  it do
    fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスクのタイトル'
    fill_in I18n.t('activemodel.attributes.task_creation.description'), with: 'a' * 255
    click_button '作成する'
    expect(page).to have_link('タスクのタイトル')
  end

  it do
    fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスクのタイトル'
    fill_in I18n.t('activemodel.attributes.task_creation.tag_words'), with: 'a' * 17
    click_button '作成する'
    expect(page).to have_content("タグ「#{'a' * 17}」は16文字以内で入力してください")
  end

  it do
    fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスクのタイトル'
    fill_in I18n.t('activemodel.attributes.task_creation.tag_words'), with: "#{'a' * 16} #{'b' * 17}"
    click_button '作成する'
    expect(page).to have_content("タグ「#{'b' * 17}」は16文字以内で入力してください")
  end

  it do
    fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスクのタイトル'
    fill_in I18n.t('activemodel.attributes.task_creation.tag_words'), with: "#{'a' * 8} #{'a' * 9}"
    click_button '作成する'
    expect(page).to have_link('タスクのタイトル')
  end
end
