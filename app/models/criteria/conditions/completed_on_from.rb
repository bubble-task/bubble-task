module Criteria
  module Conditions
    CompletedOnFrom = Struct.new(:datetime) do
      extend Creatable

      def prepare(relation)
        relation.plan_association(completed_tasks: :outer)
      end

      def satisfy(relation)
        relation.restrict_by_completed_after(datetime)
      end
    end
  end
end
