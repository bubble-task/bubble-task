require 'rails_helper'

describe '自身が作成したタスクの一覧' do
  it do
    user_a_hash = {
      'provider' => 'google',
      'uid' => '1234567890',
      'info' => {
        'email' => 'user.a@gaiax.com',
        'name' => 'User AAA'
      }
    }
    user_b_hash = {
      'provider' => 'google',
      'uid' => '1234567890',
      'info' => {
        'email' => 'user.b@gaiax.com',
        'name' => 'Test BBB'
      }
    }

    user_a = create_user_from_oauth_credential(user_a_hash)
    user_b = create_user_from_oauth_credential(user_b_hash)

    user_b_task = user_b.create_task('ユーザBのタスク').tap(&:save)

    oauth_sign_in(:google, user_a_hash['info'])
    visit root_path
    expect(page).to_not have_link('ユーザBのタスク')
  end
end
