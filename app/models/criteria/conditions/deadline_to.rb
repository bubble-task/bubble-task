module Criteria
  module Conditions
    DeadlineTo = Struct.new(:datetime) do
      extend Creatable

      def prepare(plans)
        plans.add(task_deadline: :left_outer)
      end

      def satisfy(relation)
        relation.restrict_by_deadline_before(datetime)
      end
    end
  end
end
