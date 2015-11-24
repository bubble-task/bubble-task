require 'rails_helper'

describe 'タグの一覧画面' do
  before do
    create_user_from_oauth_credential(auth_hash)
    oauth_sign_in(auth_hash: auth_hash)
  end

  def create_task(*args)
    TaskFactory
      .create(*args)
      .tap(&:save)
  end

  let(:auth_hash) { generate_auth_hash }

  let(:tags) { all('.tag').map(&:text) }

  it do
    create_task(1, 'タスクのタイトル', nil, ['タグ'])
    visit tags_path
    expect(tags).to eq(%w(タグ))
  end

  it do
    create_task(1, 'タスクのタイトル', nil, %w(タグB タグC タグA))
    visit tags_path
    expect(tags).to eq(%w(タグA タグB タグC))
  end
end
