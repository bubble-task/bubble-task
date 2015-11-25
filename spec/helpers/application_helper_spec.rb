require 'rails_helper'

describe ApplicationHelper do
  skip 'activate_menu' do
    it do
      allow(described_class)
      r = activate_menu({ 'home' => 'index' })
      expect(r).to be_true
    end
  end
end
