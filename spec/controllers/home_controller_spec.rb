require 'rails_helper'

describe HomeController do
  describe '#index' do
    context 'ログインしていない場合' do
      skip do
        get :index
        expect(response).to redirect_to(new_session_url)
      end
    end
  end
end
