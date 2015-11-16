require 'rails_helper'

describe HomeController do
  describe '#index' do
    subject do
      get :index
      response
    end

    context 'ログインしていない場合' do
      it { is_expected.to redirect_to(new_session_url) }
    end

    context 'ログインしている場合' do
      before { sign_in }
      it { is_expected.to be_ok }
    end
  end
end
