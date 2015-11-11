class OauthCallbacksController < ApplicationController
  include SignInHelper

  def create
    auth_hash = request.env['omniauth.auth']
    user = UserRepository.new.find_by_oauth_credential(auth_hash)
    sign_in(user)
    redirect_to home_url
  end
end
