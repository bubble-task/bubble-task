require 'rails_helper'

describe TasksController do
  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }
  let(:task) { create_task(user.id, 'title', '', []) }

  describe '#new' do
    subject { get :new }

    context 'ログインしていない場合' do
      it { is_expected.to redirect_to(new_session_url) }
    end

    context 'ログインしている場合' do
      before { sign_in }
      it { is_expected.to be_ok }
    end
  end

  describe '#create' do
    subject { post :create }

    context 'ログインしていない場合' do
      it { is_expected.to redirect_to(new_session_url) }
    end

    context 'ログインしている場合' do
      before { sign_in }
      it { is_expected.to be_ok }
    end
  end

  describe '#show' do
    subject { get :show, id: task.id }

    let(:task) { Task.create(author_id: 1, title: 'title') }

    context 'ログインしていない場合' do
      it { is_expected.to redirect_to(new_session_url) }
    end

    context 'ログインしている場合' do
      before { sign_in }
      it { is_expected.to be_ok }
    end
  end

  describe '#index' do
    subject { get :index }

    context 'ログインしていない場合' do
      it { is_expected.to redirect_to(new_session_url) }
    end

    context 'ログインしている場合' do
      before { sign_in }
      it { is_expected.to be_ok }
    end
  end

  describe '#edit' do
    subject { get :edit, id: task.id }

    context 'ログインしていない場合' do
      it { is_expected.to redirect_to(new_session_url) }
    end

    context 'ログインしている場合' do
      before { sign_in }
      it { is_expected.to be_ok }
    end
  end

  describe '#update' do
    subject { put :update, id: task.id }

    context 'ログインしていない場合' do
      it { is_expected.to redirect_to(new_session_url) }
    end

    context 'ログインしている場合' do
      before { sign_in }
      it { is_expected.to be_ok }
    end
  end

  describe '#complete' do
    subject { xhr :post, :complete, id: task.id }

    context 'ログインしていない場合' do
      it { is_expected.to redirect_to(new_session_url) }
    end

    context 'ログインしている場合' do
      before { sign_in }
      it { is_expected.to render_template(:complete, format: :js) }
    end
  end

  describe '#destroy' do
    context 'ログインしている場合' do
      before { sign_in(user) }

      context 'http' do
        subject { delete :destroy, id: task.id }
        it { is_expected.to redirect_to(root_url) }
      end

      context 'xhr' do
        subject { xhr :delete, :destroy, id: task.id }
        it { is_expected.to render_template('destroy', format: :js) }
      end
    end
  end
end
