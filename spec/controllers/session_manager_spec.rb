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
    context 'ログインしている場合' do
      it do
        session = {}
        expected_user = create_user_from_oauth_credential
        SessionManager.sign_in(session, expected_user)
        user = SessionManager.current_user(session)
        expect(user).to eq(expected_user)
      end
    end

    context 'ログインしていない場合' do
      it do
        session = {}
        user = SessionManager.current_user(session)
        expect(user).to be_nil
      end
    end

    context 'セッションが残っている状態でユーザがすでに削除されている場合' do
      it do
        session = {}
        user = create_user_from_oauth_credential
        SessionManager.sign_in(session, user)
        user.destroy
        empty_user = SessionManager.current_user(session)
        expect(empty_user).to be_nil
      end
    end
  end

  describe '渡されたセッションからユーザのidを削除する' do
    it do
      session = {}
      user = create_user_from_oauth_credential
      signed_in_session = SessionManager.sign_in(session, user)

      new_session = SessionManager.sign_out(signed_in_session)
      expect(new_session[:user_id]).to be_nil
    end
  end
end
