require 'rails_helper'

describe 'タグの一覧画面' do
  let(:auth_hash) { generate_auth_hash }

  it do
    user = create_user_from_oauth_credential(auth_hash)
    oauth_sign_in(auth_hash: auth_hash)
    task = user.create_task('タスクのタイトル', nil, ['タグ'])
    task.save
    visit tags_path
    expect(page).to have_content('タグ')
  end
end
