require 'rails_helper'

describe User do
  it 'OAuthユーザの情報から新規のユーザを作成する' do
    auth_hash = {
      'provider' => 'google',
      'uid' => '1234567890',
      'info' => {
        'email' => 'user@gaiax.com',
        'name' => 'TestUser'
      }
    }
    user = User.create_from_oauth_user(auth_hash)
    expect(user.provider).to eq auth_hash['provider']
    expect(user.uid).to eq auth_hash['uid']
    expect(user.email).to eq auth_hash['info']['email']
    expect(user.name).to eq auth_hash['info']['name']
  end

  it 'OAuthユーザの情報から既存のユーザを取得する' do
    auth_hash = {
      'provider' => 'google',
      'uid' => '1234567890',
      'info' => {
        'email' => 'user@gaiax.com',
        'name' => 'TestUser'
      }
    }
    User.create_from_oauth_user(auth_hash)
    created_user = User.last

    user = User.find_by_oauth_credential(auth_hash['provider'], auth_hash['uid'])
    expect(user).to eq(created_user)
  end
end
