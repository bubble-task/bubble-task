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
      fill_in I18n.t('activemodel.attributes.task_form.title'), with: 'タスクのタイトル'
      click_button '作成する'
      click_link 'タスクのタイトル'
      title = find('#task_title').text
      description = find('#task_description').text
      expect(title).to eq 'タスクのタイトル'
      expect(description).to eq ''
    end

    it do
      fill_in I18n.t('activemodel.attributes.task_form.title'), with: 'タスクのタイトル'
      fill_in I18n.t('activemodel.attributes.task_form.description'), with: 'タスクの説明'
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
      fill_in I18n.t('activemodel.attributes.task_form.title'), with: ''
      click_button '作成する'
      expect(page).to have_content 'タイトルを入力してください'
    end

    it do
      title = 'a' * 80
      fill_in I18n.t('activemodel.attributes.task_form.title'), with: title
      click_button '作成する'
      expect(page).to have_link(title)
    end

    it do
      fill_in I18n.t('activemodel.attributes.task_form.title'), with: 'a' * 81
      click_button '作成する'
      expect(page).to have_content 'タイトルは半角80文字以内で入力してください'
    end

    it do
      fill_in I18n.t('activemodel.attributes.task_form.title'), with: 'タスクのタイトル'
      fill_in I18n.t('activemodel.attributes.task_form.description'), with: 'a' * 511
      click_button '作成する'
      expect(page).to have_content '説明は半角510文字以内で入力してください'
    end

    it do
      fill_in I18n.t('activemodel.attributes.task_form.title'), with: 'タスクのタイトル'
      fill_in I18n.t('activemodel.attributes.task_form.description'), with: 'a' * 510
      click_button '作成する'
      expect(page).to have_link('タスクのタイトル')
    end
  end
end
