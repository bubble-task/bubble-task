module Criteria
  class AssociationBuilder

    def initialize(relation)
      @relation = relation
      @plan_set = Set.new
    end

    def plan_association(plan)
      @plan_set << plan
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
        @plan_set << { taggings: :left_outer } if @plan_set.empty?
      end

      def join_clause
        associations = @plan_set.each_with_object([]) do |plan, a|
          relation = plan.keys.first.to_s.pluralize
          join_type = plan.values.first.to_s.upcase.tr('_', ' ')
          a << "#{join_type} JOIN #{relation} ON #{relation}.task_id = tasks.id"
        end
        join_clause = associations.join(' ')
      end

      def associated_relations
        @plan_set.map { |p| p.keys.first }
      end
  end
end
