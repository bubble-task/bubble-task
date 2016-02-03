require 'rails_helper'

describe TaskParameters do
  describe '#deadline' do
    it do
      params = described_class.new
      params.deadline_date = '2016/02/01'
      params.deadline_hour = '8'
      params.deadline_minutes = '0'
      expect(params.deadline).to eq(Time.zone.parse('2016/02/01 08:00'))
    end
  end
end
