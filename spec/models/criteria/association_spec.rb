require 'rails_helper'

describe Criteria::Association do
  describe '#to_sql' do
    context '単数形で渡す場合' do
      it do
        association = described_class.new(:task, :left_outer, :completed_task)
        sql = association.to_sql
        expect(sql).to eq('LEFT OUTER JOIN completed_tasks ON completed_tasks.task_id = tasks.id')
      end
    end

    context '複数形で渡す場合' do
      it do
        association = described_class.new(:tasks, :left_outer, :completed_tasks)
        sql = association.to_sql
        expect(sql).to eq('LEFT OUTER JOIN completed_tasks ON completed_tasks.task_id = tasks.id')
      end
    end

    context '一語のJOIN' do
      it do
        association = described_class.new(:task, :inner, :taggings)
        sql = association.to_sql
        expect(sql).to eq('INNER JOIN taggings ON taggings.task_id = tasks.id')
      end
    end
  end
end
