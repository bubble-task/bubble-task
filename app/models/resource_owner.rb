class ResourceOwner
  Credential = Struct.new(:provider, :uid)

  def initialize(auth_hash)
    @name, @email = auth_hash['info'].values_at('name', 'email')
    @credential = Credential.new(*auth_hash.values_at('provider', 'uid'))
  end

  def create_user
    User.new(name: @name, email: @email) do |user|
      user.build_oauth_credential(@credential.to_h)
      user.save
    end
  end

  def find_user
    oauth_credential = OauthCredential.find_by(@credential.to_h)
    return nil unless oauth_credential
    oauth_credential.user
  end

  def email_domain
    @email.split('@').last
  end
end
