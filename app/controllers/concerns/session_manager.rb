module SessionManager
  module_function

  def sign_in(session, user)
    session[:user_id] = user.id
    session
  end

  def current_user(session)
    User.find(session[:user_id])
  end
end
