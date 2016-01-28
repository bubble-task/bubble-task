module Criteria
  class AssociationBuilder

    def initialize(relation)
      @relation = relation
      @plans = Set.new
    end

    def plan_association(plan)
      @plans << plan
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
        unless @plans.include?({ completed_task: :inner })
          @plans << { completed_task: :left_outer }
        end
        unless @plans.include?({ taggings: :inner })
          @plans << { taggings: :left_outer }
        end

        if @plans.include?({ completed_task: :inner }) &&
          @plans.include?({ completed_task: :left_outer })
          @plans.delete({ completed_task: :left_outer })
        end
      end

      def join_clause
        associations = @plans.each_with_object([]) do |plan, a|
          relation = plan.keys.first.to_s.pluralize
          join_type = plan.values.first.to_s.upcase.tr('_', ' ')
          a << "#{join_type} JOIN #{relation} ON #{relation}.task_id = tasks.id"
        end
        join_clause = associations.join(' ')
      end

      def associated_relations
        @plans.map { |p| p.keys.first }
      end
  end
end
