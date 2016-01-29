require 'rails_helper'

module Criteria
  describe AssociationPlan do
    describe '#associate' do
      context '関連名が単数形' do
        it do
          plan = described_class.new(:completed_task, :left_outer)
          association = plan.associate(:task)
          expect(association).to eq(Association.new('tasks', 'left_outer', 'completed_tasks'))
        end
      end
    end
  end
end
