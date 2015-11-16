require_relative './user_helper'

module SignInHelper
  include UserHelper

  def oauth_sign_in(user = { email: nil, name: nil })
    auth_hash = default_auth_hash.merge(user)
    OmniAuth.config.add_mock(:google, auth_hash)
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
    visit oauth_callbacks_path(provider: :google)
  end

  def request_oauth_sign_in(user = { email: nil, name: nil })
    auth_hash = default_auth_hash.merge(user)
    OmniAuth.config.add_mock(:google, auth_hash)
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
    get oauth_callbacks_path(provider: :google)
    follow_redirect!
  end

  def sign_in(user_params = { email: nil, name: nil })
    user = User.new(default_auth_hash['info'].merge(user_params))
    allow(controller).to receive(:current_user) { user }
  end
end
