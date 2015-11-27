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
  end
end
