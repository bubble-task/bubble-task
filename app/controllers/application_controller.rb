class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def sign_in(user)
    SessionManager.sign_in(session, user)
  end

  def current_user
    SessionManager.current_user(session)
  end

  helper_method :current_user
end
