require 'rails_helper'

describe AssignmentsController do
  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }
  let(:task) { create_task(author_id: user.id, title: 'title') }

  describe '#create' do
    subject { xhr :post, :create, task_id: task.id }

    context 'ログインしていない場合' do
      it { is_expected.to redirect_to(new_session_url) }
    end

    context 'ログインしている場合' do
      before { sign_in(user) }
      it { is_expected.to be_ok }
    end
  end
end
