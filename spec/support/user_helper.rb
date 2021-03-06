module UserHelper

  def create_user_from_oauth_credential(auth_hash = generate_auth_hash)
    owner = ResourceOwner.new(auth_hash)
    owner.create_user
  end

  def generate_auth_hash(provider: 'google', email: 'user@gaiax.com', name: 'ユーザ 名前')
    {
      'provider' => provider,
      'uid' => generate_uid,
      'info' => {
        'email' => email,
        'name' => name
      }
    }
  end

  def retrieve_auth_hash(user)
    oauth_credential = user.oauth_credential
    {
      'provider' => oauth_credential.provider,
      'uid' => oauth_credential.uid,
      'info' => {
        'email' => user.email,
        'name' => user.name
      }
    }
  end

  def generate_uid
    (1..16).to_a.shuffle.join
  end
end
