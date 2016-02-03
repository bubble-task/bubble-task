module Criteria
  class AssociationBuilder

    def initialize(relation)
      @relation = relation
      @plans = AssociationPlanSet.new
    end

    def build(conditions)
      aggregate_plans!(conditions)
      finalize_plans!
      @relation.joins(@plans.join_clause(@relation.table_name)).preload(*@plans.associated_relations)
    end

    private

      def aggregate_plans!(conditions)
        conditions.inject(@plans) { |p, c| c.prepare(p) }
      end

      def finalize_plans!
        completed_task_inner = { completed_task: :inner }
        completed_task_left_outer = { completed_task: :left_outer }
        taggings_inner = { taggings: :inner }
        taggings_left_outer = { taggings: :left_outer }

        unless @plans.planed_inner_join?(:completed_task)
          @plans << completed_task_left_outer
        end

        unless @plans.planed_inner_join?(:taggings)
          @plans << taggings_left_outer
        end

        if @plans.include?(completed_task_inner) &&
          @plans.include?(completed_task_left_outer)
          @plans.delete(completed_task_left_outer)
        end
      end
  end
end
