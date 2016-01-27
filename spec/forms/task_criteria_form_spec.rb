require 'rails_helper'

describe TaskCriteriaForm do
  describe '#has_additional_condition?' do
    subject do
      described_class
        .new(1, conditions)
        .has_additional_condition?
    end

    let(:base_conditions) do
      { from_date: nil, to_date: nil, tag_words: nil, is_signed_up_only: '1' }
    end

    context 'given from_date' do
      let(:conditions) { base_conditions.merge(from_date: '2015-01-23') }
      it { is_expected.to be_truthy }
    end

    context 'given to_date' do
      let(:conditions) { base_conditions.merge(to_date: '2015-01-23') }
      it { is_expected.to be_truthy }
    end

    context 'given tag_words' do
      let(:conditions) { base_conditions.merge(tag_words: 'aaa bbb ccc') }
      it { is_expected.to be_truthy }
    end

    context 'given is_signed_up_only' do
      let(:conditions) { base_conditions.merge(is_signed_up_only: '0') }
      it { is_expected.to be_truthy }
    end

    context 'given all additional conditions' do
      let(:conditions) do
        { from_date: '2015-01-23', to_date: '2015-03-21', tag_words: 'aaa', is_signed_up_only: '0' }
      end
      it { is_expected.to be_truthy }
    end

    context 'NOT given any params' do
      let(:conditions) { base_conditions }
      it { is_expected.to be_falsey }
    end
  end
end
