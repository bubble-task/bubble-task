require 'rails_helper'

describe BackwardNavigator, type: :model do
  describe '#backward_path' do
    subject do
      navigator.update_backward_path(current_path)
      navigator.backward_path
    end

    let(:navigator) { described_class.new({}, backable_paths) }

    context 'register "/", "/tasks" as backable path' do
      let(:backable_paths) { %w(/ /tasks) }

      context 'visit /' do
        let(:current_path) { '/' }
        it { is_expected.to eq('/') }
      end

      context 'visit /tasks' do
        let(:current_path) { '/tasks' }
        it { is_expected.to eq('/tasks') }
      end

      context 'visit /tasks?tag=ABC' do
        let(:current_path) { '/tasks?tag=ABC' }
        it { is_expected.to eq(current_path) }
      end

      context 'visit /tasks/new' do
        let(:current_path) { '/tasks/new' }
        it { is_expected.to eq('/') }
      end

      context 'visit / => /tasks/new' do
        it do
          navigator.update_backward_path('/')
          navigator.update_backward_path('/tasks/new')
          expect(navigator.backward_path).to eq('/')
        end
      end

      context 'visit /tasks => /tasks/new => /tasks/new' do
        it do
          navigator.update_backward_path('/tasks')
          navigator.update_backward_path('/tasks/new')
          navigator.update_backward_path('/tasks/new')
          expect(navigator.backward_path).to eq('/tasks')
        end
      end

      context 'visit /tasks => / => /tasks/new' do
        it do
          navigator.update_backward_path('/tasks')
          navigator.update_backward_path('/')
          navigator.update_backward_path('/tasks/new')
          expect(navigator.backward_path).to eq('/')
        end
      end
    end
  end
end
