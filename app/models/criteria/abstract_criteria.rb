module Criteria
  class AbstractCriteria

    def initialize
      @conditions = []
      @preparation = nil
      @sorter = nil
    end

    def add_condition(condition)
      @conditions << condition
    end

    def satisfy(relation)
      finalize_conditions
      prepared_relation = prepare_relation(relation)
      satisfied_relation = satisfy_relation(prepared_relation).uniq
      @sorter.call(satisfied_relation)
    end

    def set_preparation(&block)
      @preparation = block
    end

    def set_sorter(&block)
      @sorter = block
    end

    private

      def finalize_conditions
        @conditions.flatten!
      end

      def prepare_relation(relation)
        builder = AssociationBuilder.new(relation)
        builder.build(@conditions, &@preparation)
      end

      def satisfy_relation(relation)
        @conditions.inject(relation) { |r, c| c.satisfy(r) }
      end
  end
end
