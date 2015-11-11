class UserRepository

  def initialize(user)
    @user = user
  end

  def find_by_oauth_credential(auth_hash)
    user = @user.find_by_oauth_credential(auth_hash['provider'], auth_hash['uid'])
    return user if user
    @user.create_from_oauth_user(auth_hash)
  end
end
