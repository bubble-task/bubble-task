class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  delegate :sign_in, :current_user, to: :session_manager
  helper_method :current_user

  private

    def session_manager
      @session_manager ||= SessionManager.new(session)
    end
end
