module UserHelper

  def create_user_from_oauth_credential(auth_hash = default_auth_hash)
    User.create_from_oauth_user(auth_hash)
  end

  def default_auth_hash
    {
      'provider' => 'google',
      'uid' => '1234567890',
      'info' => {
        'email' => 'user@gaiax.com',
        'name' => 'TestUser'
      }
    }
  end
end
