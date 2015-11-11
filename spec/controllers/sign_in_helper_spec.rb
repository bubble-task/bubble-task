require 'rails_helper'

class FakeController
  include SignInHelper

  attr_reader :session

  def initialize
    @session = {}
  end
end

FakeUser = Struct.new(:id)

describe SignInHelper do
  describe '#sign_in' do
    it do
      controller = FakeController.new
      user = FakeUser.new(123)
      controller.sign_in(user)
      expect(controller.session[:user_id]).to eq(user.id)
    end
  end

  describe 'ログインしているユーザを取得する' do
    it do
      expected_user = create_user_from_oauth_credential
      controller = FakeController.new
      controller.sign_in(expected_user)
      user = controller.current_user
      expect(user).to eq(expected_user)
    end
  end
end
