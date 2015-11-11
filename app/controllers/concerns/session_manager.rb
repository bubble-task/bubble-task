module SessionManager
  module_function

  def sign_in(session, user)
    session[:user_id] = user.id
    session
  end

  def current_user(session)
    return nil unless session[:user_id]
    User.find_by(id: session[:user_id])
  end
end
