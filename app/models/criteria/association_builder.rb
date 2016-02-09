module Criteria
  class AssociationBuilder

    def initialize(relation)
      @relation = relation
    end

    def build(conditions)
      plans = aggregate_plans(conditions)
      finalize_plans(plans)
      @relation
        .joins(plans.join_clause(@relation.table_name))
        .preload(*plans.relations)
    end

    private

      def aggregate_plans(conditions)
        conditions.inject(AssociationPlanSet.new) { |p, c| c.prepare(p) }
      end

      def finalize_plans(plans)
        unless plans.planned_inner_join?(:taggings)
          plans.add(taggings: :left_outer)
        end

        unless plans.planned_inner_join?(:completed_task)
          plans.add(completed_task: :left_outer)
        end

        if plans.planned_inner_join?(:completed_task) &&
          plans.planned_left_outer_join?(:completed_task)
          plans.delete(completed_task: :left_outer)
        end
      end
  end
end
