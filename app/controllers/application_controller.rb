class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= SessionManager.current_user(session)
  end

  def signed_in?
    current_user != nil
  end

  def backward_path
    backward_navigator.backward_path
  end

  helper_method :current_user, :signed_in?, :backward_path

  protected

    def authorize!
      redirect_to new_session_url, notice: I18n.t('sessions.alert.must_sign_in') unless current_user
    end

    def sign_in(user)
      SessionManager.sign_in(session, user)
    end

    def update_backward_path
      backward_navigator.update_backward_path(request.fullpath)
    end

  private

    def backward_navigator
      @backward_navigator ||= BackwardNavigator.new(session)
    end
end
