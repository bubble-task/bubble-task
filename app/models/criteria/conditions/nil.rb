module Criteria
  module Conditions
    module Nil
      module_function

      def prepare(relation)
        relation
      end

      def satisfy(relation)
        relation
      end
    end
  end
end
