module Criteria
  class AssociationPlanSet

    def initialize
      @plans = Set.new
    end

    def add(plan)
      @plans << create_plan_from_hash(plan)
      self
    end

    def include?(plan)
      @plans.include?(create_plan_from_hash(plan))
    end

    def join_clause(table_name)
      @plans
        .map { |p| p.associate(table_name) }
        .map(&:to_sql)
        .join(' ')
    end

    def relations
      @plans.map(&:relation)
    end

    def planned_inner_join?(relation)
      include?(relation => :inner)
    end

    private

      def create_plan_from_hash(spec)
        relation, join_type = spec.flatten
        AssociationPlan.new(relation, join_type)
      end
  end
end
