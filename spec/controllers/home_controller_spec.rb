require 'rails_helper'

describe HomeController do
  describe '#index' do
    context 'ログインしていない場合' do
      it do
        get :index
        expect(response).to redirect_to(new_session_url)
      end
    end

    context 'ログインしている場合' do
      before { sign_in }

      it do
        get :index
        expect(response).to be_ok
      end
    end
  end
end
