require 'rails_helper'

class UserSpy

  attr_accessor :auth_hash

  def find
    nil
  end

  def create(auth_hash)
    self.auth_hash =  auth_hash
  end
end

describe UserRepository do
  context 'ユーザがまだ登録されていない場合' do
    it 'Userに新規のユーザを作成させる' do
      auth_hash = {}
      spy = UserSpy.new
      UserRepository.new(spy).find_by_oauth_credential(auth_hash)
      expect(spy.auth_hash).to eq auth_hash
    end
  end
end
