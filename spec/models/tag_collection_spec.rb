require 'rails_helper'

describe TagCollection do
  describe '#remove_all!' do
    let(:tags) { described_class.new }

    it do
      tags.add(%w(タグ1 タグ2))
      tags.remove_all!
      expect(tags.tags).to be_empty
    end
  end
end
