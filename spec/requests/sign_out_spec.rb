require 'rails_helper'

describe 'ログアウト' do
  context 'ログインしている場合' do
    before do
      request_oauth_sign_in
      delete session_path
    end

    it 'ログインページに遷移していること' do
      expect(response).to redirect_to(new_session_url)
      follow_redirect!
      expect(response.body).to include(I18n.t('sessions.notice.signed_out'))
    end

    it 'ホーム画面にアクセスできないこと' do
      get root_path
      expect(response).to redirect_to(new_session_url)
    end
  end

  context 'ログインしていない場合' do
    it 'ログインページにリダイレクトされること' do
      delete session_path
      expect(response).to redirect_to(new_session_url)
      follow_redirect!
      expect(response.body).to include(I18n.t('sessions.alert.must_sign_in'))
    end
  end
end
