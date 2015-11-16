class OauthCallbacksController < ApplicationController
  before_action :not_authorized!

  def create
    auth_hash = request.env['omniauth.auth']
    user = UserRepository.new.find_by_oauth_credential(auth_hash)
    sign_in(user)
    redirect_to root_url, notice: I18n.t('sessions.notice.signed_in')
  end

  private

    def not_authorized!
      redirect_to root_url
    end
end
