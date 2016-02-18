module Criteria
  module Conditions
    module Assignee

      def self.create(searcher_id, assignee_id)
        return Anyone.new(searcher_id) unless assignee_id
        Assigned.new(assignee_id)
      end
    end

    Assigned = Struct.new(:user_id) do

      def prepare(plans)
        plans.add(assignments: :left_outer)
      end

      def satisfy(relation)
        relation.restrict_by_assignee_or_personal_task(user_id)
      end
    end

    Anyone = Struct.new(:searcher_id) do

      def prepare(relation)
        relation
      end

      def satisfy(relation)
        relation.restrict_by_public_task_or_searchers_personal_task(searcher_id)
      end
    end
  end
end
