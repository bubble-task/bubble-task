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
