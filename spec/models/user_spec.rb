require 'rails_helper'

describe User do
  describe 'OAuthユーザの情報から新規のユーザを作成する' do
    it do
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
  end

  describe 'OAuthユーザの情報からユーザを取得する' do
    context '既にユーザが登録されている場合' do
      it do
        auth_hash = {
          'provider' => 'google',
          'uid' => '1234567890',
          'info' => {
            'email' => 'user@gaiax.com',
            'name' => 'TestUser'
          }
        }
        created_user = User.create_from_oauth_user(auth_hash)
        user = User.find_by_oauth_credential(auth_hash['provider'], auth_hash['uid'])
        expect(user).to eq(created_user)
      end
    end

    context 'ユーザが登録されていない場合' do
      it do
        auth_hash = {
          'provider' => 'google',
          'uid' => '1234567890',
          'info' => {
            'email' => 'user@gaiax.com',
            'name' => 'TestUser'
          }
        }
        user = User.find_by_oauth_credential(auth_hash['provider'], auth_hash['uid'])
        expect(user).to be_nil
      end
    end
  end
end
