require 'rails_helper'

describe 'ログアウト' do
  context 'ログインしている場合' do
    before do
      request_oauth_sign_in
      delete session_path
    end

    it 'ログインページに遷移していること' do
      expect(response).to redirect_to(new_session_url)
    end

    it 'ホーム画面にアクセスできないこと' do
      get root_path
      expect(response).to redirect_to(new_session_url)
    end
  end
end
