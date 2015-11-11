require 'rails_helper'

describe SessionManager do
  describe '渡されたセッションにユーザのidを保存する' do
    it do
      session = {}
      user = create_user_from_oauth_credential
      new_session = SessionManager.sign_in(session, user)
      expect(new_session[:user_id]).to eq(user.id)
    end
  end

  describe 'ログインしているユーザを取得する' do
    it do
      session = {}
      expected_user = create_user_from_oauth_credential
      SessionManager.sign_in(session, expected_user)
      user = SessionManager.current_user(session)
      expect(user).to eq(expected_user)
    end
  end
end
