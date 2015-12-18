module Criteria
  module Creatable
    module NilCondition
      module_function

      def satisfy(relation)
        relation
      end
    end

    def create(value)
      return NilCondition unless value
      new(value)
    end
  end
end
