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
      conditions.inject(self) { |b, c| c.prepare(b) }

      @plan_set << { taggings: :left_outer } if @plan_set.empty?

      associations = @plan_set.each_with_object([]) do |plan, a|
        relation = plan.keys.first.to_s.pluralize
        join_type = plan.values.first.to_s.upcase.tr('_', ' ')
        a << "#{join_type} JOIN #{relation} ON #{relation}.task_id = tasks.id"
      end
      join_clause = associations.join(' ')

      associated_relations = @plan_set.map { |p| p.keys.first }

      @relation.joins(join_clause).preload(*associated_relations)
    end
  end
end
