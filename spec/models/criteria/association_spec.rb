require 'rails_helper'

describe Criteria::Association do
  skip '#to_sql' do
    it do
      association = described_class.new(:tasks, :left_outer, :complted_tasks)
      sql = association.to_sql
      expect(sql).to eq('LEFT OUTER JOIN completed_tasks ON completed_tasks.task_id = tasks.id')
    end
  end
end
