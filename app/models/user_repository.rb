class UserRepository

  def find_by_oauth_credential(auth_hash)
    user = User.find_by_oauth_credential(auth_hash['provider'], auth_hash['uid'])
    return user if user
    User.create_from_oauth_user(auth_hash)
  end
end
