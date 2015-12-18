require 'rails_helper'

describe AchievementCriteriaForm do
  describe '#has_condition?' do
    subject do
      described_class
        .new(from_date: from_date, to_date: to_date)
        .has_condition?
    end

    context 'given from_date' do
      let(:from_date) { '2015-01-23' }
      let(:to_date) { nil }
      it { is_expected.to be_truthy }
    end

    context 'given to_date' do
      let(:from_date) { nil }
      let(:to_date) { '2015-01-23' }
      it { is_expected.to be_truthy }
    end

    context 'given from_date and to_date' do
      let(:from_date) { '2015-01-23' }
      let(:to_date) { '2015-02-12' }
      it { is_expected.to be_truthy }
    end

    context 'NOT given any params' do
      let(:from_date) { nil }
      let(:to_date) { nil }
      it { is_expected.to be_falsey }
    end
  end
end
