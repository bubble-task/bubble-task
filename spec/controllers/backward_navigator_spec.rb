require 'rails_helper'

describe BackwardNavigator, type: :model do
  describe '#backward_path' do
    let(:navigator) { described_class.new(storage) }

    context 'when storage is empty' do
      let(:storage) { {} }

      it do
        expect(navigator.backward_path).to eq('/')
      end
    end

    context 'when /tasks stored' do
      let(:storage) { { 'backward_path' => '/tasks' } }

      context 'current = "/tasks/123"' do
        let(:current_path) { '/tasks/123' }

        it do
          navigator.update_backward_path(current_path)
          expect(navigator.backward_path).to eq(current_path)
        end
      end
    end
  end
end
