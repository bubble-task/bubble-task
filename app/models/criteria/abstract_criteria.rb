module Criteria
  class AbstractCriteria

    def initialize
      @conditions = []
    end

    def add_condition(condition)
      @conditions << condition
    end

    def satisfy(relation)
      finalize_conditions
      prepared_relation = prepare_relation(relation)
      satisfy_relation(prepared_relation).uniq.order(:id)
    end

    def set_preparation(&block)
      @preparation = block
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
