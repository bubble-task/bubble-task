require 'rails_helper'

FakeUser = Struct.new(:id)

describe SessionManager do

  describe '渡されたセッションにユーザのidを保存する' do
    it do
      session = {}
      manager = SessionManager.new(session)
      user = create_user_from_oauth_credential
      manager.sign_in(user)
      expect(session[:user_id]).to eq(user.id)
    end
  end

  describe 'ログインしているユーザを取得する' do
    it do
      session = {}
      manager = SessionManager.new(session)
      expected_user = create_user_from_oauth_credential
      manager.sign_in(expected_user)
      user = manager.current_user
      expect(user).to eq(expected_user)
    end
  end
end
