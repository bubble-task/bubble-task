require 'rails_helper'

describe '自身が作成したタスクの一覧' do
  let(:user_a_auth_hash) { generate_auth_hash }
  let(:user_a) { create_user_from_oauth_credential(user_a_auth_hash) }
  let(:user_b) { create_user_from_oauth_credential(generate_auth_hash) }
  let(:create_task_for_user_b) { create_task(author_id: user_b.id, title: 'ユーザBのタスク') }

  before do
    user_a
    user_b
  end

  it do
    create_task_for_user_b

    oauth_sign_in(auth_hash: user_a_auth_hash)
    visit root_path
    expect(page).to_not have_link('ユーザBのタスク')
  end
end
