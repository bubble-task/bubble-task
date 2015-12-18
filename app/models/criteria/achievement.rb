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
      relation = relation.restrict_by_complated
      @conditions.reduce(relation) { |r, c| c.satisfy(r) }
    end
  end
end
