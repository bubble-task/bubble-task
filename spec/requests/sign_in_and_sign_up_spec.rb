require 'rails_helper'

describe 'GET /auth/google/callback' do
  context 'OAuth認証に成功した場合' do
    it 'ログイン状態になっていること' do
      OmniAuth.config.add_mock(
        :google,
        {
          'provider' => 'google',
          'uid' => '1234567890',
          'info' => {
            'email' => 'user@gaiax.com',
            'name' => 'TestUser'
          }
        }
      )
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
      get(oauth_callbacks_path(provider: :google))
      follow_redirect!
      expect(response.body).to include 'TestUser'
    end
  end
end
