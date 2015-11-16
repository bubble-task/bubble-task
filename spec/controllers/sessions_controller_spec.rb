require 'rails_helper'

describe SessionsController do
  describe '#new' do
    context 'ログインしていない場合' do
      it do
        get :new
        expect(response).to_not redirect_to(root_path)
      end
    end

    context 'ログインしている場合' do
      before { sign_in }

      it do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
