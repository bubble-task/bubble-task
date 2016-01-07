module Criteria
  class Achievement

    def initialize
      @conditions = []
      yield(self) if block_given?
    end

    def add_condition(condition)
      @conditions << condition
    end

    def satisfy(relation)
      @conditions.flatten!
      prepared_relation = @conditions.inject(relation) { |r, c| c.prepare(r) }.relation
      default_relation = prepared_relation.restrict_by_complated
      tasks = @conditions.inject(default_relation) { |r, c| c.satisfy(r) }
      tasks.sort_by(&:completed_at)
    end
  end
end
