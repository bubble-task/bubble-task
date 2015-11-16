require 'rails_helper'

describe 'ログアウト' do
  context 'ログインしている場合' do
    before { oauth_sign_in }

    it do
      visit root_path
      find('.sign-out', visible: false).click
      expect(current_path).to eq(new_session_path)
    end
  end
end
