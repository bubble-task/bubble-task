require 'rails_helper'

describe 'タスクの完了', js: true do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
    task
  end

  let(:task) { create_task(user.id, 'タスクのタイトル', nil, []) }
  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }

  it do
    visit root_path
    puts page.html
    find("#task_#{task.id}_completion", visible: false).click
    visit root_path
    check_box = find("#task_#{task.id}_completion_check", visible: false)
    expect(check_box).to be_checked
  end
end
