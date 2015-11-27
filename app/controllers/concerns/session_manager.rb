module SessionManager
  SESSION_KEY = :user_id

  module_function

  def sign_in(session, user)
    session[SESSION_KEY] = user.id
  end

  def sign_out(session)
    session.delete(SESSION_KEY)
  end

  def current_user(session)
    return nil unless session[SESSION_KEY]
    User.find_by(id: session[SESSION_KEY])
  end
end
