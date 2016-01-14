require 'rails_helper'

describe BackwardNavigator, type: :model do
  def ReqPath(string)
    RequestPath.new(string)
  end

  describe '#backward_path' do
    subject do
      navigator.update_backward_path(current_path)
      navigator.backward_path
    end

    let(:navigator) { described_class.new({}, backable_paths) }

    context 'register "/", "/tasks" as backable path' do
      let(:backable_paths) { %w(/ /tasks).map { |p| ReqPath(p) } }

      context 'visit /' do
        let(:current_path) { ReqPath('/') }
        it { is_expected.to eq(current_path) }
      end

      context 'visit /tasks' do
        let(:current_path) { ReqPath('/tasks') }
        it { is_expected.to eq(current_path) }
      end

      context 'visit /tasks?tag=ABC' do
        let(:current_path) { ReqPath('/tasks?tag=ABC') }
        it { is_expected.to eq(current_path) }
      end

      context 'visit /tasks/new' do
        let(:current_path) { ReqPath('/tasks/new') }
        it { is_expected.to eq(ReqPath('/')) }
      end

      context 'visit / => /tasks/new' do
        it do
          navigator.update_backward_path(ReqPath('/'))
          navigator.update_backward_path(ReqPath('/tasks/new'))
          expect(navigator.backward_path).to eq(ReqPath('/'))
        end
      end

      context 'visit /tasks => /tasks/new => /tasks/new' do
        it do
          navigator.update_backward_path(ReqPath('/tasks'))
          navigator.update_backward_path(ReqPath('/tasks/new'))
          navigator.update_backward_path(ReqPath('/tasks/new'))
          expect(navigator.backward_path).to eq(ReqPath('/tasks'))
        end
      end

      context 'visit /tasks => / => /tasks/new' do
        it do
          navigator.update_backward_path(ReqPath('/tasks'))
          navigator.update_backward_path(ReqPath('/'))
          navigator.update_backward_path(ReqPath('/tasks/new'))
          expect(navigator.backward_path).to eq(ReqPath('/'))
        end
      end
    end
  end
end
