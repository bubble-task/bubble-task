require 'rails_helper'

describe BackwardNavigator, type: :model do
  describe '#backward_path' do
    subject do
      navigator.update_backward_path(current_path)
      navigator.backward_path
    end

    let(:navigator) { described_class.new({}, backable_paths) }

    context 'register "/", "/tasks" as backable path' do
      let(:backable_paths) { %w(/ /tasks).map { |p| RequestPath.new(p) } }

      context 'visit /' do
        let(:current_path) { RequestPath.new('/') }
        it { is_expected.to eq(current_path) }
      end

      context 'visit /tasks' do
        let(:current_path) { RequestPath.new('/tasks') }
        it { is_expected.to eq(current_path) }
      end

      context 'visit /tasks?tag=ABC' do
        let(:current_path) { RequestPath.new('/tasks?tag=ABC') }
        it { is_expected.to eq(current_path) }
      end

      context 'visit /tasks/new' do
        let(:current_path) { RequestPath.new('/tasks/new') }
        it { is_expected.to eq(RequestPath.new('/')) }
      end

      context 'visit / => /tasks/new' do
        it do
          navigator.update_backward_path(RequestPath.new('/'))
          navigator.update_backward_path(RequestPath.new('/tasks/new'))
          expect(navigator.backward_path).to eq(RequestPath.new('/'))
        end
      end

      context 'visit /tasks => /tasks/new => /tasks/new' do
        it do
          navigator.update_backward_path(RequestPath.new('/tasks'))
          navigator.update_backward_path(RequestPath.new('/tasks/new'))
          navigator.update_backward_path(RequestPath.new('/tasks/new'))
          expect(navigator.backward_path).to eq(RequestPath.new('/tasks'))
        end
      end

      context 'visit /tasks => / => /tasks/new' do
        it do
          navigator.update_backward_path(RequestPath.new('/tasks'))
          navigator.update_backward_path(RequestPath.new('/'))
          navigator.update_backward_path(RequestPath.new('/tasks/new'))
          expect(navigator.backward_path).to eq(RequestPath.new('/'))
        end
      end
    end
  end
end
