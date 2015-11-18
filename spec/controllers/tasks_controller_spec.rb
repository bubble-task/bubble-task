require 'rails_helper'

describe TasksController do
  describe '#new' do
    subject do
      get :new
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

  describe '#create' do
    subject do
      post :create
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

  describe '#show' do
    subject do
      get :show, id: task.id
      response
    end

    let(:task) { Task.create(author_id: 1, title: 'title') }

    context 'ログインしていない場合' do
      it { is_expected.to redirect_to(new_session_url) }
    end

    context 'ログインしている場合' do
      before { sign_in }
      it { is_expected.to be_ok }
    end
  end
end
