module Criteria
  module Conditions
    CompletedOnTo = Struct.new(:datetime) do
      extend Creatable

      def prepare(relation)
        relation.plan_association(completed_task: :left_outer)
      end

      def satisfy(relation)
        relation.restrict_by_completed_before(datetime)
      end
    end
  end
end
