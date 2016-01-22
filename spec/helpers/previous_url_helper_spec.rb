require 'rails_helper'

module PreviousUrlHelper
  class DummyView
    include ApplicationHelper
    include Rails.application.routes.url_helpers
    default_url_options[:host] = 'http://test.host'

    Request = Struct.new(:referrer)

    attr_reader :request

    def initialize(previous_url)
      @request = Request.new(previous_url)
    end
  end
end

describe PreviousUrlHelper do
  describe '#previous_url_for_task' do
    subject do
      view = PreviousUrlHelper::DummyView.new(previous_url)
      view.previous_url_for_task
    end

    context 'リファラがタスク編集ページのURL以外' do
      let(:previous_url) { tasks_url(tag: :abc) }
      it { is_expected.to eq(previous_url) }
    end

    context 'リファラがタスク編集ページのURL' do
      let(:previous_url) { edit_task_url(1) }
      it { is_expected.to eq(root_url) }
    end

    context 'リファラがタスク詳細ページのURL' do
      let(:previous_url) { task_url(1) }
      it { is_expected.to eq(root_url) }
    end
  end

  describe '#from_show_task?' do
    subject do
      view.from_show_task?
    end

    let(:view) { described_class::DummyView.new(referer) }

    context 'from show task' do
      let(:referer) { '/tasks/123' }
      it { is_expected.to be_truthy }
    end

    context 'from index tasks' do
      let(:referer) { '/tasks' }
      it { is_expected.to be_falsey }
    end
  end

  describe '#from_home?' do
    subject do
      view.from_home?
    end

    let(:view) { described_class::DummyView.new(referer) }

    context 'from home' do
      let(:referer) { '/' }
      it { is_expected.to be_truthy }
    end

    context 'from index tasks' do
      let(:referer) { '/tasks' }
      it { is_expected.to be_falsey }
    end
  end
end
