class ResourceOwner

  def initialize(auth_hash)
    @auth_hash = auth_hash
  end

  def create_user
    User.new do |user|
      user.name = @auth_hash['info']['name']
      user.email = @auth_hash['info']['email']
      user.build_oauth_credential(provider: @auth_hash['provider'], uid: @auth_hash['uid'])
      user.save
    end 
  end

  def find_user
    oauth_credential = OauthCredential.find_by(provider: @auth_hash['provider'], uid: @auth_hash['uid'])
    return nil unless oauth_credential
    oauth_credential.user
  end
end
