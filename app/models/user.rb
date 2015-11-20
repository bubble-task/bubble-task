class User < ActiveRecord::Base
  has_one :oauth_credential

  delegate :provider, :uid, to: :oauth_credential

  def create_task(title, description = nil, tags = [])
    TaskFactory.create(id, title, description, tags)
  end
end
