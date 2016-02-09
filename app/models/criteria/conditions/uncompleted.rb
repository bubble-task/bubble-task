module Criteria
  module Conditions
    module Uncompleted
      module_function

      def prepare(plans)
        plans.add(completed_task: :left_outer)
      end

      def satisfy(relation)
        relation.restrict_by_uncompleted
      end
    end
  end
end
