module Criteria
  module Conditions
    CompletedOnFrom = Struct.new(:datetime) do
      extend Creatable

      def prepare(plans)
        plans.add(completed_task: :inner)
      end

      def satisfy(relation)
        relation.restrict_by_completed_after(datetime)
      end
    end
  end
end
