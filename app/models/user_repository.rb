module UserRepository
  class << self

    def find_by_oauth_credential(auth_hash)
      resource_owner = ResourceOwner.new(auth_hash)
      return nil unless permitted_email_domain?(resource_owner.email_domain)
      user = resource_owner.find_user
      return user if user
      resource_owner.create_user
    end

    private

      def permitted_email_domain?(email_domain)
        %w(gaiax.com adish.co.jp).include?(email_domain)
      end
  end
end
