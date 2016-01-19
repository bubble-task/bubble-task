require 'rails_helper'

describe BackwardNavigator, type: :model do
  describe '.detect_backward_path' do
    context 'register "/" and "/tasks" as backable_paths' do
      before do
        described_class.register_backable_paths(%w(/ /tasks))
      end

      context 'current is backable referer is nil' do
        it do
          r = described_class.detect_backward_path('/tasks', nil)
          expect(r).to eq('/tasks')
        end
      end

      context 'current == referer' do
        it do
          r = described_class.detect_backward_path('/tasks', '/tasks')
          expect(r).to eq('/tasks')
        end
      end

      context 'current is backable referer is NOT backable"' do
        it do
          r = described_class.detect_backward_path('/tasks', '/tasks/123')
          expect(r).to eq('/tasks')
        end
      end

      context 'current is backable referer is other backable' do
        it do
          r = described_class.detect_backward_path('/', '/tasks')
          expect(r).to eq('/tasks')
        end
      end

      context 'current is backable referer is other backable with QUERY_STRING' do
        it do
          r = described_class.detect_backward_path('/', '/tasks?tag=ABC')
          expect(r).to eq('/tasks?tag=ABC')
        end
      end
    end
  end

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
