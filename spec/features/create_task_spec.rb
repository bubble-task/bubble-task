require 'rails_helper'

describe 'タスクを登録する' do
  it do
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
    fill_in I18n.t('activemodel.attributes.task_form.title'), with: 'タスクのタイトル'
    fill_in I18n.t('activemodel.attributes.task_form.description'), with: 'タスクの説明'
    click_button '作成する'
    expect(page).to have_content 'タスクのタイトル'
  end
end
