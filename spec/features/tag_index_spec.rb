require 'rails_helper'

describe 'タグの一覧画面' do
  before do
    create_user_from_oauth_credential(auth_hash)
    oauth_sign_in(auth_hash: auth_hash)
  end

  let(:auth_hash) { generate_auth_hash }

  let(:tags) { all('.tag').map(&:text) }

  it do
    create_task(author_id: 1, title: 'タスクのタイトル', tags: ['タグ'])
    visit tags_path
    expect(tags).to eq(%w(タグ))
  end

  it do
    create_task(author_id: 1, title: 'タスクのタイトル', tags: %w(タグB タグC タグA))
    visit tags_path
    expect(tags).to eq(%w(タグA タグB タグC))
  end

  it '半角英数、全角の順に並んでいること', skip_ci: true do
    create_task(author_id: 1, title: 'タスク1', tags: %w(AAA あああ 456))
    create_task(author_id: 1, title: 'タスク2', tags: %w(いいい))
    create_task(author_id: 1, title: 'タスク3', tags: %w(123 CCC))
    visit tags_path
    expect(tags).to eq(%w(123 456 AAA CCC あああ いいい))
  end
end
