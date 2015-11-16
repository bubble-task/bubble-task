module UserHelper

  def oauth_sign_in(user = { emai: nil, name: nil })
    auth_hash = default_auth_hash.merge(user)
    OmniAuth.config.add_mock(:google, auth_hash)
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
    visit oauth_callbacks_path(provider: :google)
  end

  def create_user_from_oauth_credential(auth_hash = default_auth_hash)
    User.create_from_oauth_user(auth_hash)
  end

  def default_auth_hash
    {
      'provider' => 'google',
      'uid' => '1234567890',
      'info' => {
        'email' => 'user@gaiax.com',
        'name' => 'TestUser'
      }
    }
  end
end
