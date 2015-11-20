module UserRepository
  module_function

  def find_by_oauth_credential(auth_hash)
    resource_owner = ResourceOwner.new(auth_hash)
    user = resource_owner.find_user
    return user if user
    resource_owner.create_user
  end
end
