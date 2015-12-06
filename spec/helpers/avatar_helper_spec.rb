require 'rails_helper'

module AvatarHelper
  class DummyView
    include AvatarHelper

    def javascript_tag(content)
      content
    end
  end
end

describe AvatarHelper do
  describe '#show_avatar_image' do
    let(:c) { AvatarHelper::DummyView.new }

    let(:user) do
      double(:user).tap { |d| allow(d).to receive(:email) { 'user@e.mail' } }
    end

    it do
      expect(c.show_avatar_image(user, force: true)).to_not be_nil
    end
  end
end
