require 'rails_helper'

describe 'タスクを登録する' do
  before do
    OmniAuth.config.add_mock(
      :google,
      {
        'provider' => 'google',
        'uid' => '1234567890',
        'info' => {
          'email' => 'user@gaiax.com',
          'name' => 'ユーザの名前',
        },
      },
    )
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
    visit oauth_callbacks_path(provider: :google)
    visit new_task_path
  end

  describe 'タスクを作成する' do
    it do
      fill_in I18n.t('activemodel.attributes.task_creation.title'), with: 'タスクのタイトル'
      click_button '作成する'
      click_link 'タスクのタイトル'
      title = find('#task_title').text
      description = find('#task_description').text
      expect(title).to eq 'タスクのタイトル'
      expect(description).to eq ''
    end

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

  describe 'バリデーションをかける' do
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
  end
end
