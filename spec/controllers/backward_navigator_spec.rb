require 'rails_helper'

describe BackwardNavigator, type: :model do
  describe '#backward_path_for' do
    subject do
      described_class.register_backable_paths(backable_paths)
      nav = described_class.update_backable_path(current_path)
      path = nav.backward_path
    end

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

      context 'visit /tasks/new' do
        let(:current_path) { '/tasks/new' }
        it { is_expected.to eq('/') }
      end
    end
  end
end
