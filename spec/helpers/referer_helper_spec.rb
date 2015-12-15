require 'rails_helper'

module RefererHelper
  class DummyView
    attr_reader :request

    Request = Struct.new(:referer)

    def initialize(referer)
      @request = Request.new(referer)
    end
  end
end

describe RefererHelper do
  describe '#from_show_task?' do
    subject do
      v.from_show_task?
    end

    let(:v) do
      described_class::DummyView
        .new(referer)
        .extend(RefererHelper)
    end

    context 'from show task' do
      let(:referer) { '/tasks/123' }
      it { is_expected.to be_truthy }
    end

    context 'from index tasks' do
      let(:referer) { '/tasks' }
      it { is_expected.to be_falsey }
    end
  end
end
