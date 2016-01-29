module Criteria
  class AssociationBuilder

    def initialize(relation)
      @relation = relation
      @plans = Set.new
    end

    def plan_association(plan)
      relation, join_type = plan.flatten
      @plans << AssociationPlan.new(relation, join_type)
      self
    end

    def build(conditions)
      aggregate_plans!(conditions)
      finalize_plans!
      @relation.joins(join_clause).preload(*associated_relations)
    end

    private

      def aggregate_plans!(conditions)
        conditions.inject(self) { |b, c| c.prepare(b) }
      end

      def finalize_plans!
        completed_task_inner = AssociationPlan.new(:completed_task, :inner)
        completed_task_left_outer = AssociationPlan.new(:completed_task, :left_outer)
        taggings_inner = AssociationPlan.new(:taggings, :inner)
        taggings_left_outer = AssociationPlan.new(:taggings, :left_outer)

        unless @plans.include?(completed_task_inner)
          @plans << completed_task_left_outer
        end

        unless @plans.include?(taggings_inner)
          @plans << taggings_left_outer
        end

        if @plans.include?(completed_task_inner) &&
          @plans.include?(completed_task_left_outer)
          @plans.delete(completed_task_left_outer)
        end
      end

      def join_clause
        @plans
          .map { |p| p.associate(:task) }
          .map(&:to_sql)
          .join(' ')
      end

      def associated_relations
        @plans.map(&:relation)
      end
  end
end
