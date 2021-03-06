class OauthCallbacksController < ApplicationController
  before_action :not_authorized!

  def create
    auth_hash = request.env['omniauth.auth']
    user = UserRepository.find_by_oauth_credential(auth_hash)
    if user
      sign_in(user)
      redirect_to root_url, notice: I18n.t('sessions.notice.signed_in')
    else
      redirect_to new_session_url, alert: I18n.t('sessions.alert.unavailable_email')
    end
  end

  private

    def not_authorized!
      redirect_to root_url if signed_in?
    end
end
