module Criteria
  module Conditions
    module Completed
      module_function

      def prepare(plans)
        plans.add(completed_task: :inner)
      end

      def satisfy(relation)
        relation.restrict_by_completed
      end
    end
  end
end
