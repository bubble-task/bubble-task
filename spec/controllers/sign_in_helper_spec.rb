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
end
