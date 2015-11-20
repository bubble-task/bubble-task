require 'rails_helper'

describe ResourceOwner do
  let(:auth_hash) do
    {
      'provider' => 'google',
      'uid' => '1234567890',
      'info' => {
        'email' => 'user@gaiax.com',
        'name' => 'TestUser',
      },
    }
  end

  let(:owner) { described_class.new(auth_hash) }

  describe 'OAuthユーザの情報から新規のユーザを作成する' do
    it do
      user = owner.create_user
      expect(user.provider).to eq auth_hash['provider']
      expect(user.uid).to eq auth_hash['uid']
      expect(user.email).to eq auth_hash['info']['email']
      expect(user.name).to eq auth_hash['info']['name']
    end
  end

  describe 'OAuthユーザの情報からユーザを取得する' do
    context '既にユーザが登録されている場合' do
      it do
        created_user = owner.create_user
        user = owner.find_user
        expect(user).to eq(created_user)
      end
    end

    context 'ユーザが登録されていない場合' do
      it do
        user = owner.find_user
        expect(user).to be_nil
      end
    end
  end
end
