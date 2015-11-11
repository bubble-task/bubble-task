class User < ActiveRecord::Base
  has_one :oauth_credential

  def self.create_from_oauth_user(auth_hash)
    user = new(name: auth_hash['info']['name'], email: auth_hash['info']['email'])
    user.build_oauth_credential(provider: auth_hash['provider'], uid: auth_hash['uid'])
    user.save
  end

  def provider
    oauth_credential.provider
  end

  def uid
    oauth_credential.uid
  end
end
