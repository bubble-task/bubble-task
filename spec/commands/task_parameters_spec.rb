require 'rails_helper'

describe TaskParameters do
  describe '#deadline' do
    let(:params) { described_class.new }

    context 'given date, hour and minutes' do
      it do
        params.deadline_date = '2016/02/01'
        params.deadline_hour = '8'
        params.deadline_minutes = '0'
        expect(params.deadline).to eq(Time.zone.parse('2016/02/01 08:00'))
      end
    end

    context 'given date and hour' do
      it do
        params.deadline_date = '2016/02/01'
        params.deadline_hour = '8'
        expect(params.deadline).to eq(Time.zone.parse('2016/02/01 08:00'))
      end
    end
  end
end
