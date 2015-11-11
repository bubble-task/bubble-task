class ApplicationController < ActionController::Base

  def sign_in(user)
    manager = SessionManager.new(session)
    manager.sign_in(user)
  end

  def current_user
    manager = SessionManager.new(session)
    manager.current_user
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
end
