require 'rails_helper'

describe TaskParameters do
  describe '#deadline' do
    let(:params) { described_class.new }

    let(:deadline) { params.deadline }

    context 'given date, hour and minutes' do
      it do
        params.deadline_date = '2016/02/01'
        params.deadline_hour = '8'
        params.deadline_minutes = '0'
        expect(deadline).to eq(Time.zone.parse('2016/02/01 08:00'))
      end
    end

    context 'given date and hour' do
      it do
        params.deadline_date = '2016/02/01'
        params.deadline_hour = '8'
        params.deadline_minutes = ''
        expect(deadline).to eq(Time.zone.parse('2016/02/01 08:00'))
      end
    end

    context 'given date' do
      it do
        params.deadline_date = '2016/02/22'
        params.deadline_hour = ''
        params.deadline_minutes = ''
        expect(deadline).to eq(Time.zone.parse('2016/02/22 00:00:00'))
      end
    end

    context 'given no parameters' do
      it do
        params.deadline_date = ''
        params.deadline_hour = ''
        params.deadline_minutes = ''
        expect(deadline).to be_nil
      end
    end
  end
end
