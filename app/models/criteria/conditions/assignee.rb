module Criteria
  module Conditions
    module Assignee

      def self.create(user_id)
        return Anyone unless user_id
        Assigned.new(user_id)
      end
    end

    Assigned = Struct.new(:id) do

      def prepare(plans)
        plans.add(assignments: :inner)
      end

      def satisfy(relation)
        relation.restrict_by_assignee(id)
      end
    end

    module Anyone
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
