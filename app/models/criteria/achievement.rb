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
      initial_relation = relation.restrict_by_complated.order('completed_tasks.completed_at')
      @conditions.inject(initial_relation) { |r, c| c.satisfy(r) }
    end
  end
end
