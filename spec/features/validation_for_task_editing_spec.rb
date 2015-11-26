require 'rails_helper'

describe 'タスク編集時にバリデーションをかける' do
  before do
    user
    oauth_sign_in(auth_hash: auth_hash)
    task
  end

  let(:user) { create_user_from_oauth_credential(auth_hash) }
  let(:auth_hash) { generate_auth_hash }

  let(:task) { create_task(user.id, old_title, old_description, old_tags) }
  let(:old_title) { '編集前のタイトル' }
  let(:old_description) { '編集前の説明' }
  let(:old_tags) { %w(タグ1 タグ2) }
  let(:old_tag_words) { old_tags.join(' ') }

  let(:valid_title) { 'タスクのタイトル' }
  let(:out_of_boundary_length) { 17 }
  let(:inside_of_boundary_length) { 16 }

  skip do
    visit edit_task_url(task.id)
    fill_in 'task_editing[title]', with: ''
    expect(page).to have_content 'タイトルを入力してください'
  end
end
