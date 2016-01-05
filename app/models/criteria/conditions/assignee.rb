module Criteria
  module Conditions
    Assignee = Struct.new(:id) do
      extend Creatable

      def satisfy(relation)
        relation.restrict_by_assignee(id)
      end
    end
  end
end
