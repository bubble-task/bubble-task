class AddIndexToOauthCredentials < ActiveRecord::Migration
  def change
    add_index(:oauth_credentials, [:provider, :uid], unique: true)
  end
end
