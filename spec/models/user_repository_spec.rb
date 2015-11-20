require 'rails_helper'

describe UserRepository do
  context 'ユーザが登録されている場合' do
    it '登録されているユーザを返す' do
      auth_hash = generate_auth_hash
      expected_user = create_user_from_oauth_credential(auth_hash)
      user = described_class.find_by_oauth_credential(auth_hash)
      expect(user).to eq(expected_user)
    end
  end

  context 'ユーザがまだ登録されていない場合' do
    it 'Userに新規のユーザを作成させる' do
      user = described_class.find_by_oauth_credential(generate_auth_hash)
      expected_user = User.last
      expect(user).to eq(expected_user)
    end
  end
end
