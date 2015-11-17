require 'rails_helper'

describe User do
  let(:auth_hash) do
    {
      'provider' => 'google',
      'uid' => '1234567890',
      'info' => {
        'email' => 'user@gaiax.com',
        'name' => 'TestUser',
      },
    }
  end
  describe 'OAuthユーザの情報から新規のユーザを作成する' do
    it do
      user = User.create_from_oauth_user(auth_hash)
      expect(user.provider).to eq auth_hash['provider']
      expect(user.uid).to eq auth_hash['uid']
      expect(user.email).to eq auth_hash['info']['email']
      expect(user.name).to eq auth_hash['info']['name']
    end
  end

  describe 'OAuthユーザの情報からユーザを取得する' do
    context '既にユーザが登録されている場合' do
      it do
        created_user = User.create_from_oauth_user(auth_hash)
        user = User.find_by_oauth_credential(auth_hash['provider'], auth_hash['uid'])
        expect(user).to eq(created_user)
      end
    end

    context 'ユーザが登録されていない場合' do
      it do
        user = User.find_by_oauth_credential(auth_hash['provider'], auth_hash['uid'])
        expect(user).to be_nil
      end
    end
  end

  describe 'タスクを作成する' do
    context 'タスクの説明がない場合' do
      it do
        user = User.new(id: 1)
        task = user.create_task('タスクのタイトル')
        expect(task.title).to eq('タスクのタイトル')
        expect(task.author_id).to eq(user.id)
      end
    end

    context 'タスクの説明がある場合' do
      it do
        user = User.new(id: 1)
        task = user.create_task('タスクのタイトル', 'タスクの説明')
        expect(task.title).to eq('タスクのタイトル')
        expect(task.description).to eq('タスクの説明')
        expect(task.author_id).to eq(user.id)
      end
    end

    context 'タグが付加されている場合' do
      it do
        user = User.new(id: 1)
        task = user.create_task('タスクのタイトル', '', ['タグ1', 'タグ2'])
        expect(task.tag_contents).to eq(['タグ1', 'タグ2'])
        expect(task.title).to eq('タスクのタイトル')
        expect(task.author_id).to eq(user.id)
      end
    end
  end
end
