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
      @conditions.reduce(relation) { |r, c| c.satisfy(r) }
    end
  end
end
