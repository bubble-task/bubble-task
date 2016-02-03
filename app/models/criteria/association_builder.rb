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
        unless @plans.planed_inner_join?(:completed_task)
          @plans << { completed_task: :left_outer }
        end

        unless @plans.planed_inner_join?(:taggings)
          @plans << { taggings: :left_outer }
        end

        if @plans.planed_inner_join?(:completed_task) &&
          @plans.include?(completed_task: :left_outer)
          @plans.delete(completed_task: :left_outer)
        end
      end
  end
end
