require 'rails_helper'

describe '自身が作成したタスクの一覧' do
  it do
    user_a_auth_hash = generate_auth_hash
    user_a = create_user_from_oauth_credential(generate_auth_hash)
    user_b = create_user_from_oauth_credential(generate_auth_hash)

    user_b_task = user_b.create_task('ユーザBのタスク').tap(&:save)

    oauth_sign_in(auth_hash: user_a_auth_hash)
    visit root_path
    expect(page).to_not have_link('ユーザBのタスク')
  end
end
