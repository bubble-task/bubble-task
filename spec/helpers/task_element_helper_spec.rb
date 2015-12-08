require 'rails_helper'

describe TaskElementHelper do
  let(:view) { Class.new.extend(described_class) }

  describe '#task_summary_css_id' do
    it do
      r = view.task_summary_css_id(123)
      expect(r).to eq('task_123')
    end
  end

  describe '#task_completion_css_id' do
    it do
      r = view.task_completion_css_id(123)
      expect(r).to eq('task_123_completion_state')
    end
  end
end
