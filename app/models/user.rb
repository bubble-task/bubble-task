class User < ActiveRecord::Base
  has_one :oauth_credential

  delegate :provider, :uid, to: :oauth_credential

  class << self

    def create_from_oauth_user(auth_hash)
      new do |user|
        user.name = auth_hash['info']['name']
        user.email = auth_hash['info']['email']
        user.build_oauth_credential(provider: auth_hash['provider'], uid: auth_hash['uid'])
        user.save
      end
    end

    def find_by_oauth_credential(provider, uid)
      OauthCredential.find_by(provider: provider, uid: uid).user
    end
  end
end
