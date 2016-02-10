require 'rails_helper'

describe 'GET /auth/google/callback' do
  context 'OAuth認証に成功した場合' do
    context 'gaiax.comの場合' do
      it 'ログイン状態になっていること' do
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
        get(oauth_callbacks_path(provider: :google))
        follow_redirect!
        expect(response.body).to include('ユーザの名前')
      end
    end

    context 'adish.co.jpの場合' do
      it 'ログイン状態になっていること' do
        OmniAuth.config.add_mock(
          :google,
          {
            'provider' => 'google',
            'uid' => '1234567890',
            'info' => {
              'email' => 'user@adish.co.jp',
              'name' => 'ユーザの名前',
            },
          },
        )
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
        get(oauth_callbacks_path(provider: :google))
        follow_redirect!
        expect(response.body).to include('ユーザの名前')
      end
    end

    context 'gmail.comの場合' do
      it '登録エラーになっていること' do
        OmniAuth.config.add_mock(
          :google,
          {
            'provider' => 'google',
            'uid' => '1234567890',
            'info' => {
              'email' => 'user@gmai.com',
              'name' => 'ユーザの名前',
            },
          },
        )
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
        get(oauth_callbacks_path(provider: :google))
        follow_redirect!
        expect(response.body).to include('お使いのメールアドレスではご利用いただけません')
      end
    end
  end
end
