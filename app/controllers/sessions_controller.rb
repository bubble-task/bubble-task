class SessionsController < ApplicationController
  layout 'sign_in'

  before_action :authorize!, only: [:destroy]

  def new
    redirect_to root_url if signed_in?
  end

  def destroy
    SessionManager.sign_out(session)
    redirect_to new_session_url, notice: I18n.t('sessions.notice.signed_out')
  end
end
