module Criteria
  module Conditions
    DeadlineFrom = Struct.new(:datetime) do
      extend Creatable

      def prepare(plans)
        plans.add(task_deadline: :inner)
      end

      def satisfy(relation)
        relation.where('task_deadlines.datetime >= ?', datetime)
      end
    end
  end
end
