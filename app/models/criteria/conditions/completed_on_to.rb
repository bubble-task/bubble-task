module Criteria
  module Conditions
    CompletedOnTo = Struct.new(:datetime) do
      extend Creatable

      def prepare(plans)
        plans.add(completed_task: :inner)
      end

      def satisfy(relation)
        relation.restrict_by_completed_before(datetime)
      end
    end
  end
end
