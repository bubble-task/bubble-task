module UserRepository
  module_function

  def find_by_oauth_credential(auth_hash)
    return nil unless auth_hash['info']['email'] =~ /@gaiax\.com\z/ || auth_hash['info']['email'] =~ /@adish\.co\.jp\z/
    resource_owner = ResourceOwner.new(auth_hash)
    user = resource_owner.find_user
    return user if user
    resource_owner.create_user
  end
end
