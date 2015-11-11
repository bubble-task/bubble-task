class SessionManager

  def initialize(session)
    @session = session
  end

  def sign_in(user)
    @session[:user_id] = user.id
  end

  def current_user
    User.find(@session[:user_id])
  end
end
