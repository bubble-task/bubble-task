require 'rails_helper'

describe TagsController do
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

  describe '#filter' do
    subject do
      xhr :get, :filter, term: term
      JSON.parse(response.body)
    end

    before do
      sign_in
      Tagging.create(task_id: 1, tag: 'タグ1')
      Tagging.create(task_id: 1, tag: 'タグ2')
      Tagging.create(task_id: 1, tag: 'AAA')
    end

    context 'パラメータが存在しない' do
      let(:term) { nil }
      it { is_expected.to eq(%w(AAA タグ1 タグ2)) }
    end

    context 'パラメータが存在する場合' do
      let(:term) { 'タグ' }
      it { is_expected.to eq(%w(タグ1 タグ2)) }
    end

    context 'パラメータの文字列を含むタグが存在しない場合' do
      let(:term) { 'B' }
      it { is_expected.to be_empty }
    end
  end
end
