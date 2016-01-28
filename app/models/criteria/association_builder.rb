module Criteria
  class AssociationBuilder

    def initialize(relation)
      @relation = relation
      @associate_plans = []
    end

    def plan_association(plan)
      @associate_plans << plan
      self
    end

    def build(conditions)
      conditions.inject(self) { |b, c| c.prepare(b) }

      associations = @associate_plans.each_with_object([]) do |plan, a|
        relation = plan.keys.first
        join_type = plan.values.first
        a << "#{join_type.upcase} JOIN #{relation} ON #{relation}.task_id = tasks.id"
      end
      join_clause = associations.join(' ')

      associated_relations = @associate_plans.map { |p| p.keys.first }

      @relation.joins(join_clause).preload(*associated_relations)
    end
  end
end
