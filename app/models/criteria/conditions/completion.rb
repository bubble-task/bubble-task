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
          Criteria::Creatable::NilCondition
        end
      end
    end

    module Completed
      module_function

      def prepare(relation)
        relation.plan_association(completed_task: :outer)
      end

      def satisfy(relation)
        relation.restrict_by_completed
      end
    end

    module Uncompleted
      module_function

      def prepare(relation)
        relation.plan_association(completed_task: :outer)
      end

      def satisfy(relation)
        relation.restrict_by_uncompleted
      end
    end
  end
end
