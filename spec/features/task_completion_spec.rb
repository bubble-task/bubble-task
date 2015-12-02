require 'rails_helper'

describe 'タスクの完了', js: true do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
    task
    visit root_path
  end

  let(:task) { create_task(user.id, 'タスクのタイトル', nil, []) }
  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }
  let(:completed_checkbox) { find("#task_#{task.id}_completion_check", visible: false)
}

  it do
    find("#task_#{task.id}_completion", visible: false).click
    visit root_path
    expect(completed_checkbox).to be_checked
  end

  it { expect(completed_checkbox).to_not be_checked }
end
