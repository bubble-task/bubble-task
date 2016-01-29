require 'rails_helper'

module Criteria
  describe AssociationPlan do
    describe '#associate' do
      it do
        plan = described_class.new(:completed_task, :left_outer)
        association = plan.associate(:task)
        expect(association).to eq(Association.new(:task, :left_outer, :completed_task))
      end
    end
  end
end
