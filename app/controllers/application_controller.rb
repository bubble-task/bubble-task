class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    SessionManager.current_user(session)
  end

  def signed_in?
    current_user != nil
  end

  helper_method :current_user, :signed_in?

  protected

    def authorize!
      redirect_to new_session_url, notice: I18n.t('sessions.alert.must_sign_in') unless current_user
    end

    def sign_in(user)
      SessionManager.sign_in(session, user)
    end
end
