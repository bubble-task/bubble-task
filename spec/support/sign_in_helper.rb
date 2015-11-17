require_relative './user_helper'

module SignInHelper
  include UserHelper

  def oauth_sign_in(auth_hash: nil, provider: :google)
    credential = if auth_hash
                   auth_hash
                 else
                   generate_auth_hash.tap do |h|
                     create_user_from_oauth_credential(h)
                   end
                 end
    setup_omniauth_mock(provider, credential)
    visit oauth_callbacks_path(provider: provider)
  end

  def request_oauth_sign_in(auth_hash: auth_hash, provider: :google)
    auth_hash ||= generate_auth_hash
    setup_omniauth_mock(provider, auth_hash)
    get oauth_callbacks_path(provider: provider)
    follow_redirect!
  end

  def sign_in(user_params = { email: nil, name: nil })
    user = User.new(generate_auth_hash['info'].merge(user_params))
    allow(controller).to receive(:current_user) { user }
  end

  def setup_omniauth_mock(provider = :google, auth_hash)
    OmniAuth.config.add_mock(provider, auth_hash)
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[provider]
  end
end
