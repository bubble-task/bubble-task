module Criteria
  class AssociationBuilder

    def initialize(relation)
      @relation = relation
    end

    def build(conditions, &plan_finalization)
      plans = aggregate_plans(conditions)
      plan_finalization.call(plans)
      @relation
        .joins(plans.join_clause(@relation.table_name))
        .preload(*plans.relations)
    end

    private

      def aggregate_plans(conditions)
        conditions.inject(AssociationPlanSet.new) { |p, c| c.prepare(p) }
      end
  end
end
