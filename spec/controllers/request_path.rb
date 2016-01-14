require 'rails_helper'

describe RequestPath, type: :model do
  describe '#match?' do
    subject do
      base = described_class.new(base_path)
      other = described_class.new(other_path)
      base.match?(other)
    end

    context 'base = "/tasks" other = "/tasks"' do
      let(:base_path) { '/tasks' }
      let(:other_path) { '/tasks' }
      it { is_expected.to be_truthy }
    end

    context 'base = "/tasks" other = "/"' do
      let(:base_path) { '/tasks' }
      let(:other_path) { '/' }
      it { is_expected.to be_falsey }
    end

    context 'base = "/tasks" other = "/tasks/new"' do
      let(:base_path) { '/tasks' }
      let(:other_path) { '/tasks/new' }
      it { is_expected.to be_falsey }
    end

    context 'base = "/tasks" other = "/tasks?tag=TAG"' do
      let(:base_path) { '/tasks' }
      let(:other_path) { '/tasks?tag=TAG' }
      it { is_expected.to be_truthy }
    end
  end

  describe '#has_query?' do
    subject do
      described_class.new(path).has_query?
    end

    context 'given "/tasks"' do
      let(:path) { '/tasks' }
      it { is_expected.to be_falsey }
    end

    context 'given "/tasks?tag=TAG"' do
      let(:path) { '/tasks?tag=TAG' }
      it { is_expected.to be_truthy }
    end
  end
end
