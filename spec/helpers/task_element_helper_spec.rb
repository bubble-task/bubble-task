require 'rails_helper'

describe TaskElementHelper do
  describe '#css_id' do
    it do
      v = Class.new.extend(described_class)
      r = v.task_summary_css_id(123)
      expect(r).to eq('task_123')
    end
  end
end