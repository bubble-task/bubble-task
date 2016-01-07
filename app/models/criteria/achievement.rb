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
      finalize_conditions
      prepared_relation = prepare_relation(relation)
      default_relation = prepared_relation.restrict_by_complated
      satisfied_relation = satisfy_relation(default_relation)
      satisfied_relation.sort_by(&:completed_at)
    end

    private

      def finalize_conditions
        @conditions.flatten!
      end

      def prepare_relation(relation)
        @conditions.inject(relation) { |r, c| c.prepare(r) }.relation
      end

      def satisfy_relation(relation)
        @conditions.inject(relation) { |r, c| c.satisfy(r) }
      end
  end
end
