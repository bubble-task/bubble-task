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
        relation
      end

      def satisfy(relation)
        relation.restrict_by_complated
      end
    end

    module Uncompleted
      module_function

      def prepare(relation)
        relation
      end

      def satisfy(relation)
        relation.restrict_by_uncompleted
      end
    end
  end
end
