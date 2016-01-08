require 'rails_helper'

describe PathFilter do
  let(:c) { Object.new.extend(described_class) }

  describe '#filter_for_achievement' do
    it do
      referer = '/achievements?c%5Bfrom_date%5D=&c%5Bto_date%5D=&c%5Btag_words%5D=aaa'
      filtered_url = c.filter_for_achievement(referer)
      expect(filtered_url).to eq(referer)
    end

    it do
      referer = '/bad_path'
      filtered_url = c.filter_for_achievement(referer)
      expect(filtered_url).to eq('/achievements')
    end
  end
end
