require_relative './user_helper'

module SignInHelper
  include UserHelper

  def sign_in_as(user)
    oauth_sign_in(auth_hash: retrieve_auth_hash(user))
  end

  def oauth_sign_in(auth_hash: nil, provider: :google)
    credential = prepare_oauth_sign_in(auth_hash)
    setup_omniauth_mock(provider, credential)
    visit oauth_callbacks_path(provider: provider)
  end

  def request_sign_in_as(user)
    request_oauth_sign_in(auth_hash: retrieve_auth_hash(user))
  end

  def request_oauth_sign_in(auth_hash: nil, provider: :google)
    credential = prepare_oauth_sign_in(auth_hash)
    setup_omniauth_mock(provider, credential)
    get oauth_callbacks_path(provider: provider)
    follow_redirect!
  end

  def prepare_oauth_sign_in(auth_hash = nil)
    return auth_hash if auth_hash
    generate_auth_hash.tap do |h|
      create_user_from_oauth_credential(h)
    end
  end

  def sign_in(user_params = { email: nil, name: nil })
    user = if user_params.is_a?(Hash)
             User.new(generate_auth_hash['info'].merge(user_params))
           else
             user_params
           end
    allow(controller).to receive(:current_user) { user }
  end

  def setup_omniauth_mock(provider = :google, auth_hash)
    OmniAuth.config.add_mock(provider, auth_hash)
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[provider]
  end
end
