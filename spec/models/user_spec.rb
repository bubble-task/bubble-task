require 'rails_helper'

describe User do
  it 'Oauthユーザの情報から新規のユーザを作成する' do
    auth_hash = {
      'provider' => 'google',
      'uid' => '1234567890',
      'info' => {
        'email' => 'user@gaiax.com',
        'name' => 'TestUser'
      }
    }
    User.create_from_oauth_user(auth_hash)
    user = User.last
    expect(user.provider).to eq auth_hash['provider']
    expect(user.uid).to eq auth_hash['uid']
    expect(user.email).to eq auth_hash['info']['email']
    expect(user.name).to eq auth_hash['info']['name']
  end
end
