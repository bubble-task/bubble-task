require 'rails_helper'

describe 'GET /auth/google/callback' do
  context 'OAuth認証に成功した場合' do
    before do
      OmniAuth.config.add_mock(
        :google,
        {
          'provider' => 'google',
          'uid' => '1234567890',
          'info' => {
            'email' => email,
            'name' => 'ユーザの名前',
          },
        },
      )
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
      get(oauth_callbacks_path(provider: :google))
      follow_redirect!
    end

    context 'gaiax.comの場合' do
      let(:email) { 'user@gaiax.com' }

      it 'ログイン状態になっていること' do
        expect(response.body).to include('ユーザの名前')
      end
    end

    context 'adish.co.jpの場合' do
      let(:email) { 'user@adish.co.jp' }

      it 'ログイン状態になっていること' do
        expect(response.body).to include('ユーザの名前')
      end
    end

    context 'gmail.comの場合' do
      let(:email) { 'user@gmail.com' }

      it '登録エラーになっていること' do
        expect(response.body).to include('お使いのメールアドレスではご利用いただけません')
      end
    end
  end
end
