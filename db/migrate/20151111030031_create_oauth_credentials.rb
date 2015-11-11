class CreateOauthCredentials < ActiveRecord::Migration
  def change
    create_table :oauth_credentials do |t|
      t.references :user, null: false
      t.string :provider, null: false
      t.string :uid, null: false
      t.timestamps null: false
    end
  end
end
