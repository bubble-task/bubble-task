require 'rails_helper'

class UserSpy

  attr_accessor :auth_hash

  def initialize(user = nil)
    @user = user
  end

  def find_by_oauth_credential(provider, uid)
    @user
  end

  def create_from_oauth_user(auth_hash)
    self.auth_hash = auth_hash
  end
end

describe UserRepository do
  context 'ユーザが登録されている場合' do
    it '登録されているユーザを返す' do
      dummy_user = 'dummy user'
      spy = UserSpy.new(dummy_user)
      user = UserRepository.new(spy).find_by_oauth_credential({})
      expect(user).to eq dummy_user
    end
  end

  context 'ユーザがまだ登録されていない場合' do
    it 'Userに新規のユーザを作成させる' do
      auth_hash = {}
      spy = UserSpy.new(nil)
      UserRepository.new(spy).find_by_oauth_credential(auth_hash)
      expect(spy.auth_hash).to eq auth_hash
    end
  end
end
