module Criteria
  module Conditions
    DeadlineFrom = Struct.new(:datetime) do
      extend Creatable

      def prepare(plans)
        plans.add(task_deadline: :left_outer)
      end

      def satisfy(relation)
        relation.restrict_by_deadline_after(datetime)
      end
    end
  end
end
