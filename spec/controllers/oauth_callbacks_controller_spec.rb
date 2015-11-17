require 'rails_helper'

describe OauthCallbacksController do
  describe '#create' do
    subject do
      OmniAuth.config.add_mock(:google, generate_auth_hash)
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]

      get :create, provider: :google
      response
    end

    context 'ログインしていない場合' do
      it { is_expected.to redirect_to(root_url) }
    end

    context 'ログインしている場合' do
      before { sign_in }
      it { is_expected.to redirect_to(root_url) }
    end
  end
end
