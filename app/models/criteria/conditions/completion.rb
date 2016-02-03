module Criteria
  module Conditions
    module Completion

      def self.create(completion_state)
        case completion_state
        when 'completed'
          Completed
        when 'uncompleted'
          Uncompleted
        else
          Any
        end
      end
    end

    module Completed
      module_function

      def prepare(plans)
        plans.add(completed_task: :inner)
      end

      def satisfy(relation)
        relation.restrict_by_completed
      end
    end

    module Uncompleted
      module_function

      def prepare(plans)
        plans.add(completed_task: :left_outer)
      end

      def satisfy(relation)
        relation.restrict_by_uncompleted
      end
    end

    module Any
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
