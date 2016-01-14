require 'rails_helper'

describe BackwardNavigator, type: :model do
  describe '#backward_path' do
    subject do
      navigator.update_backward_path(current_path)
      navigator.backward_path
    end

    let(:navigator) { described_class.new(storage) }

    context 'when storage is empty' do
      let(:storage) { {} }

      context 'given "/tasks"' do
        let(:current_path) { '/tasks' }
        it { is_expected.to eq(current_path) }
      end
    end

    context 'when "/tasks" stored' do
      let(:storage) { { 'backward_path' => '/tasks' } }

      context 'given "/"' do
        let(:current_path) { '/' }
        it { is_expected.to eq(current_path) }
      end
    end
  end
end
