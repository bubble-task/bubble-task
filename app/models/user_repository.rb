class UserRepository

  def initialize(user)
    @user = user
  end

  def find_by_oauth_credential(auth_hash)
    user = @user.find(auth_hash)
    return user if user
    @user.create(auth_hash)
  end
end
