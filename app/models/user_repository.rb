class UserRepository

  def initialize(user)
    @user = user
  end

  def find_by_oauth_credential(auth_hash)
    @user.create(auth_hash)
  end
end
